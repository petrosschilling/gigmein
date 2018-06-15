//
//  UserModelController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 30/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import ObjectMapper
import UIKit
import PromiseKit

class ModelController{
    
    //general vars
    let dbRef: DatabaseReference = Database.database().reference()
    var user: User = User(email: "")

    //employer vars
    var jobPosts: [JobPost] = []
    var applicantsIds: [String] = []
    var jobApplicants: [User] = []
    
    //employee vars
    var jobsToApply: [JobPost] = []
    var rejectedJobIds: [String: Bool] = [:]
    var appliedJobIds: [String: Bool] = [:]
    var jobsApplied: [JobPost] = []
    
    func reset(){
        self.jobsToApply = []
        self.jobPosts = []
        self.rejectedJobIds = [:]
        self.appliedJobIds = [:]
        self.applicantsIds = []
        self.jobApplicants = []
        self.jobsApplied = []
        self.user = User(email: "")
    }
    
    func getFirebaseUser() -> FirebaseAuth.User?{
        return Auth.auth().currentUser
    }
    
    func getFirebaseUserUID() -> String{
        return (getFirebaseUser()?.uid)!
    }
    
    func logoutUser(){
        do{
            try Auth.auth().signOut()
            self.reset()
        }catch{
            print("ModelController Error: Error while signing out")
        }
    }
    
    func loadUserProfile(user: FirebaseAuth.User) -> Promise<User>{
        print("ModelController: Loading user profile")
        return Promise {seal in
            
            if(!self.user.uid.isEmpty){
                seal.fulfill(self.user)
            }
            
            self.dbRef.child("users").child(user.uid).observeSingleEvent(of: DataEventType.value, with:{ (snapshot) in
                if (!snapshot.exists()){
                    seal.reject(NSError())
                }
                if let value = snapshot.value as? [String: Any]{
                    if let user = Mapper<User>().map(JSON: value){
                        print("ModelController: Finished loading user profile")
                        seal.fulfill(user)
                    }
                }
            })
        }
    }
    
    func saveUserDetails(){
        let uid = self.user.uid
        let userJSON = self.user.toJSON()
        self.dbRef.child("users").child(uid).setValue(userJSON)
    }

    //MARK: - EMPLOYER METHODS
    
    func loadJobsPostedByLoggedUser() -> Promise<Bool>{
        
        return Promise { seal in
            self.dbRef.child("jobPosts").child("byEmployer").child(self.user.uid).observeSingleEvent(of:
                DataEventType.value, with:{ (snapshot) in
                let children = snapshot.children
                while let child = children.nextObject() as? DataSnapshot{
                    if let value = child.value as? [String: Any],
                        let jobPostData = Mapper<JobPost>().map(JSON: value){
                        self.jobPosts.append(jobPostData)
                    }
                }
                seal.fulfill(true)
            })
        }
    }
    
    func postJob(jobPost: JobPost){
        let userUID = self.user.uid
        let key = self.dbRef.child("jobPosts").child(userUID).childByAutoId().key
        jobPost.uid = key
        
        let jobPostJSON = jobPost.toJSON()
        
        self.dbRef.child("jobPosts").child("byEmployer").child(userUID).child(key).setValue(jobPostJSON)
        self.dbRef.child("jobPosts").child("all").child(key).setValue(jobPostJSON)
        self.jobPosts.append(jobPost)
    }
    
    func acceptJobApplication(user: User, job: JobPost){
        self.dbRef.child("jobApplications").child("byEmployee").child(user.uid).child(job.uid).setValue(true)
    }
    
    func loadJobApplicantsIds(jobPost: JobPost, with dispatch: DispatchGroup){// -> Promise<[String]>{
        self.applicantsIds = []
        dispatch.enter()
        let jobPostId = jobPost.uid
        
        self.dbRef.child("jobApplications").child("byJobPost").child(jobPostId).observeSingleEvent(of: DataEventType.value, with:{ (snapshot) in
            print("ModelController: Loading applicants")
            let children = snapshot.children
            while let child = children.nextObject() as? DataSnapshot{
                self.applicantsIds.append(child.key)
            }
            print("ModelController: Loading applicants finished")
            dispatch.leave()
        })
    }
    
    func loadJobApplicants(with dispatch: DispatchGroup){// -> Promise<[User]>{
        dispatch.enter()
        self.jobApplicants.removeAll()
        for s in self.applicantsIds{
            self.dbRef.child("users").queryOrderedByKey().queryEqual(toValue: s).observeSingleEvent(of: DataEventType.value, with: { (snap) in
                let uChildren = snap.children
                if let child = uChildren.nextObject() as? DataSnapshot{
                    if let uVal = child.value as? [String:Any]{
                        let u = Mapper<User>().map(JSON: uVal)
                        self.jobApplicants.append(u!)
                    }
                }
                if(self.applicantsIds.count == self.jobApplicants.count){
                    dispatch.leave()
                }
            })
        }
    }
    
    func deleteJobPost(postIndex: Int){
        
        let postId = self.jobPosts[postIndex].uid
        
        self.dbRef.child("jobPosts").child("all").child(postId).removeValue()
        self.dbRef.child("jobPosts").child("byEmployer").child(user.uid).child(postId).removeValue()
        self.dbRef.child("jobApplications").child("byJobPost").child(postId).removeValue()
        
        self.dbRef.child("jobApplications").child("byEmployee").observeSingleEvent(of: .value) { (snapshot) in
            let children = snapshot.children
            while let child = children.nextObject() as? DataSnapshot{
                self.dbRef.child("jobApplications").child("byEmployee").child(child.key).child(postId).removeValue()
            }
        }
        self.jobPosts.remove(at: postIndex)
    }
    
    func updateJobPost(jobPost: JobPost){
        self.dbRef.child("jobPosts").child("all").child(jobPost.uid).setValue(jobPost.toJSON())
        self.dbRef.child("jobPosts").child("byEmployer").child(self.user.uid).child(jobPost.uid).setValue(jobPost.toJSON())
    }
    
    //MARK: - EMPLOYEE METHODS
    
    func loadJobsToApply(tableView: UITableView) -> Promise<Bool>{
        //TODO improve filter jobs to exclude the rejected ones
        //NOTES: Load 100 jobs randomly, load all the rejected jobs ID's in a dictionary
        //compare those 100 jobs with the rejected ones in the dictionary
        //remove the ones that match from the jobs to be displayed
        return Promise { seal in
            self.dbRef.child("jobPosts").observeSingleEvent(of: DataEventType.value, with:{ (snapshot) in
                let children = snapshot.children
                while let child = children.nextObject() as? DataSnapshot{
                    let gChildren = child.children
                    while let c = gChildren.nextObject() as? DataSnapshot{
                        
                        if (self.rejectedJobIds[c.key] == nil && self.appliedJobIds[c.key] == nil){
                            if let value = c.value as? [String: Any],
                                let jobPostData = Mapper<JobPost>().map(JSON: value){
                                if(jobPostData.employer != nil){
                                    self.jobsToApply.append(jobPostData)
                                }
                            }
                        }
                        
                    }
                }
                seal.fulfill(true)
            })
        }
    }
    
    func loadAppliedJobs(with dispatch: DispatchGroup){
        self.jobsApplied = []
        dispatch.enter()
        for postId in self.appliedJobIds{
            self.dbRef.child("jobPosts").child("all").queryOrderedByKey().queryEqual(toValue: postId.key).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let children = snapshot.children
                if let child = children.nextObject() as? DataSnapshot{
                    if let post = child.value as? [String:Any]{
                        let p = Mapper<JobPost>().map(JSON: post)
                        self.jobsApplied.append(p!)
                    }
                }
                if(self.jobsApplied.count == self.appliedJobIds.count){
                    dispatch.leave()
                }
            })
        }
        
    }
    
    func rejectJob() -> Promise<Bool>{
       
        return Promise{ seal in
            self.dbRef.child("jobRejections").child(self.user.uid).child(self.jobsToApply[0].uid).setValue(true)
            self.rejectedJobIds[self.jobsToApply[0].uid] = true
            self.jobsToApply.removeFirst()
            seal.fulfill(true);
        }
        
    }
    
    func acceptJob() -> Promise<Bool>{
        
        return Promise{seal in
        
            let jobAppRef = self.dbRef.child("jobApplications")
            let jobUID = self.jobsToApply[0].uid
            let userUID = self.user.uid
            jobAppRef.child("byJobPost").child(jobUID).child(userUID).setValue(false)
            jobAppRef.child("byEmployee").child(userUID).child(jobUID).setValue(false)
            
            //Update number of job applications on database
            var val = 1
            let employerUID = self.jobsToApply[0].employer?.uid
            self.dbRef.child("jobPosts").child("byEmployer").child(employerUID!).child(jobUID).child("numberOfApplications").observeSingleEvent(of: DataEventType.value) { snapshot in
                if let i = snapshot.value as? Int{
                    val += i
                }
            }
            self.dbRef.child("jobPosts").child("byEmployer").child(employerUID!).child(jobUID).child("numberOfApplications").setValue(val)
            self.dbRef.child("jobPosts").child("all").child(employerUID!).child(jobUID).child("numberOfApplications").setValue(val)
            
            self.appliedJobIds[self.jobsToApply[0].uid] = true
            self.jobsToApply.removeFirst()
            seal.fulfill(true)
        }
    }
    
    func loadRejectedJobsIds() -> Promise<Bool>{
        return Promise { seal in
            self.dbRef.child("jobRejections").child(self.user.uid).observeSingleEvent(of: DataEventType.value, with: { snapshot in
                let children = snapshot.children
                while let child = children.nextObject() as? DataSnapshot{
                    self.rejectedJobIds[child.key] = child.value as? Bool
                }
            })
            seal.fulfill(true)
        }
    }
    
    func loadAppliedJobsIds() -> Promise<Bool>{
        return Promise { seal in
            self.dbRef.child("jobApplications").child("byEmployee").child(self.user.uid).observeSingleEvent(of: DataEventType.value, with: { snapshot in
                let children = snapshot.children
                while let child = children.nextObject() as? DataSnapshot{
                    self.appliedJobIds[child.key] = child.value as? Bool
                }
            })
            seal.fulfill(true)
        }
    }
    
}
