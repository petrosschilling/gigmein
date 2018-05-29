//
//  JobApplicantsViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 19/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class JobApplicantsViewController: UIViewController{
    
    @IBOutlet weak var tableViewApplicants: UITableView!
    
    var mc: ModelController!
    var usersThatApplied = [User]()
    
    var jobPostIndex = 0
    let dispatchGroup1 = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jobPost = self.mc.jobPosts[jobPostIndex]
        //TODO Test the loading of the users applications
        //Apply lazy request loading for users profiles
        
        
        self.mc.loadJobApplicantsIds(jobPost: jobPost, with: self.dispatchGroup1)
        self.dispatchGroup1.notify(queue: .main) {
            self.mc.loadJobApplicants(with: self.dispatchGroup2)
            self.dispatchGroup2.notify(queue: .main) {
                print("dispatch.notify called")
                self.usersThatApplied = self.mc.jobApplicants
                self.updateView()
            }
        }
        
        
//        firstly{
//            self.mc.loadJobApplicantsIds(jobPost: jobPost)
//        }.then{applicantsIds in
//            self.mc.loadJobApplicants(userIds: applicantsIds)
//        }.done{users in
//            self.usersThatApplied = users
//            self.updateView()
//        }.cauterize()
        
    }
    
    private func updateView(){
        self.tableViewApplicants.reloadData()
        self.tableViewApplicants.endUpdates()
        print("View updated")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = segue.destination as? ApplicantProfileViewController, let index = tableViewApplicants.indexPathForSelectedRow?.row{
            s.mc = self.mc
            s.user = self.mc.jobApplicants[index]
            s.job = self.mc.jobPosts[self.jobPostIndex]
        }
    }
    
}

extension JobApplicantsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersThatApplied.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDApplicantCell")
        cell?.textLabel?.text = self.usersThatApplied[indexPath.row].firstName
        
        return cell!
    }
    
    
}
