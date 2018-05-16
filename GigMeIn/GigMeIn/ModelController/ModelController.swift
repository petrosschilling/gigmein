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
    let nav: StoryboardNavigationController = StoryboardNavigationController()
    var user: User = User(email: "")
    
    
    
    //employer vars
    var jobPosts: [JobPost] = []
    
    //employee vars
    var jobsToApply: [JobPost] = []
    var rejectedJobIds: [String: Bool] = [:]
    var appliedJobIds: [String: Bool] = [:]
    
    func reset(){
        self.jobsToApply = []
        self.jobPosts = []
        self.user = User(email: "")
    }
    
    func logoutUser(){
        do{
            try Auth.auth().signOut()
            self.reset()
        }catch{
            print("Error while signing out")
        }
    }
    
    func loadUserProfile(user: FirebaseAuth.User, redirectionHandler: UIViewController){
        firstly{
            self.loadUserProfile(user: user)
        }.done{ user in
            if(user.type == UserType.EMPLOYER){
                self.nav.goToEmployerStoryBoard(viewRedirectionHandler: redirectionHandler, mc: self)
            }else if(user.type == UserType.EMPLOYEE){
                self.nav.goToEmployeeStoryBoard(viewRedirectionHandler: redirectionHandler, mc: self)
            }
            self.user = user
        }.cauterize()
    }
    
    func loadUserProfile(user: FirebaseAuth.User) -> Promise<User>{
        return Promise {seal in
            self.dbRef.child("users").child(user.uid).observeSingleEvent(of: DataEventType.value, with:{ (snapshot) in
                if let value = snapshot.value as? [String: Any]{
                    if let user = Mapper<User>().map(JSON: value){
                        seal.fulfill(user)
                    }
                }
            })
        }
    }

    //EMPLOYER METHODS
    
    func loadJobsPostedByLoggedUser() -> Promise<Bool>{
        
        return Promise { seal in
            self.dbRef.child("jobPosts").child(self.user.uid).observeSingleEvent(of: DataEventType.value, with:{ (snapshot) in
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
        
        self.dbRef.child("jobPosts").child(userUID).child(key).setValue(jobPostJSON)
        self.jobPosts.append(jobPost)
    }
    
    
    // EMPLOYEE METHODS
    
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
                                self.jobsToApply.append(jobPostData)
                            }
                        }
                        
                    }
                }
                seal.fulfill(true)
            })
        }
    }
    
    func rejectJob(){
        self.dbRef.child("rejectedJobs").child(self.user.uid).child(self.jobsToApply[0].uid).setValue(true)
        self.rejectedJobIds[self.jobsToApply[0].uid] = true
        self.jobsToApply.remove(at: 0)
    }
    
    func acceptJob(){
        self.dbRef.child("jobApplications").child("forEmployer").child(self.jobsToApply[0].uid).child(self.user.uid).setValue(true)
        self.dbRef.child("jobApplications").child("forEmployee").child(self.user.uid).child(self.jobsToApply[0].uid).setValue(true)
        self.appliedJobIds[self.jobsToApply[0].uid] = true
        self.jobsToApply.remove(at: 0)
    }
    
    func loadRejectedJobsIds() -> Promise<Bool>{
        return Promise { seal in
            self.dbRef.child("rejectedJobs").child(self.user.uid).observeSingleEvent(of: DataEventType.value, with: { snapshot in
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
            self.dbRef.child("appliedJobs").child("forEmployee").child(self.user.uid).observeSingleEvent(of: DataEventType.value, with: { snapshot in
                let children = snapshot.children
                while let child = children.nextObject() as? DataSnapshot{
                    self.appliedJobIds[child.key] = child.value as? Bool
                }
            })
            seal.fulfill(true)
        }
    }
    
    
    
    
}
