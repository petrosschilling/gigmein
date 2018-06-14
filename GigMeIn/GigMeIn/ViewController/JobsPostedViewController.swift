//
//  MainViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import PromiseKit

class JobsPostedViewController :UIViewController{
    
    @IBOutlet weak var jobsPostedTableView: UITableView!
    
    let logoutSegueID = "LogoutSegue"
    let jobsPostedToCreateJobPostSegueID = "JobsPostedToCreateJobPostSegue"
    let jobPostCellRID = "RIDJobPostCell"
    let jobsPostedToEditPostSegueID = "JobsPostedToEditPostSegue"
    
    var mc: ModelController!
    var postToEdit: JobPost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jobsPostedTableView.dataSource = self
        self.jobsPostedTableView.delegate = self
        
        firstly{
            self.mc.loadJobsPostedByLoggedUser()
        }.done{ b in
            self.updateTableView()
        }.cauterize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTableView()
    }

    func updateTableView(){
        self.jobsPostedTableView.reloadData()
        self.jobsPostedTableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createJobPostVC = segue.destination as? CreateJobPostViewController {
            createJobPostVC.modelController = self.mc
        } else if let viewApplicantsVC = segue.destination as? JobApplicantsViewController, let index = jobsPostedTableView.indexPathForSelectedRow?.row{
            viewApplicantsVC.mc = self.mc
            viewApplicantsVC.jobPostIndex = index
        } else if let editPostVC = segue.destination as? EditJobPostViewController {
            editPostVC.mc = self.mc
            editPostVC.postToEdit = self.postToEdit
        } else if let loadingVC = segue.destination as? LoadingViewController {
            loadingVC.mc = self.mc
        }
    }
    
    @IBAction func btnSOut(_ sender: Any) {
        self.mc.logoutUser()
        //performSegue(withIdentifier: self.logoutSegueID, sender: self)
        self.goToLoginStoryboard()
    }
    
    func goToLoginStoryboard(){
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginStoryID") as! LoginViewController
        loginVC.mc = self.mc
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddJobsPostPress(_ sender: Any) {
        performSegue(withIdentifier: self.jobsPostedToCreateJobPostSegueID, sender: self)
    }
}

extension JobsPostedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = self.mc{
            return m.jobPosts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.jobPostCellRID) as! JobPostCell
        if let m = self.mc{
            let jobPost = m.jobPosts[indexPath.row]
            cell.setJobPost(jobPost: jobPost)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.postToEdit = self.mc.jobPosts[index.row]
            self.performSegue(withIdentifier: self.jobsPostedToEditPostSegueID, sender: self)
        }
        edit.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.mc.deleteJobPost(postIndex: index.row)
            self.updateTableView()
        }
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    
    
    
}
