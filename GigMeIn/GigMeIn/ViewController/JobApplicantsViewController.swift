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
    
    let applicantCellID = "ApplicantCellID"
    
    var mc: ModelController!
    var usersThatApplied = [User]()
    var jobPostIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jobPost = self.mc.jobPosts[jobPostIndex]
        
        let dispatchGroup1 = DispatchGroup()
        self.mc.loadJobApplicantsIds(jobPost: jobPost, with: dispatchGroup1)
        dispatchGroup1.notify(queue: .main) {
            let dispatchGroup2 = DispatchGroup()
            self.mc.loadJobApplicants(with: dispatchGroup2)
            dispatchGroup2.notify(queue: .main) {
                self.usersThatApplied = self.mc.jobApplicants
                self.updateView()
            }
        }
        
    }
    
    private func updateView(){
        self.tableViewApplicants.reloadData()
        self.tableViewApplicants.endUpdates()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.applicantCellID)
        cell?.textLabel?.text = self.usersThatApplied[indexPath.row].firstName
        
        return cell!
    }
    
    
}
