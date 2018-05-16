//
//  MainViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 27/4/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper
import PromiseKit

class JobsPostedViewController :UIViewController{
    
    @IBOutlet weak var jobsPostedTableView: UITableView!
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Main ViewDidLoadCalled")
        
        self.jobsPostedTableView.dataSource = self
        self.jobsPostedTableView.delegate = self
        
        firstly{
            self.mc.loadJobsPostedByLoggedUser()
        }.done{ b in
            self.jobsPostedTableView.reloadData()
            self.jobsPostedTableView.endUpdates()
        }.cauterize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.jobsPostedTableView.reloadData()
        self.jobsPostedTableView.endUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createJobPostVC = segue.destination as? CreateJobPostViewController {
            createJobPostVC.modelController = self.mc
        }
    }
    
    @IBAction func btnSOut(_ sender: Any) {
        self.mc.logoutUser()
        self.mc.nav.goToLoginStoryboard(viewRedirectionHandler: self, mc: self.mc)
    }
    
    @IBAction func btnAddJobsPostPress(_ sender: Any) {
        performSegue(withIdentifier: "JobsPostedToCreateJobPostSegue", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RIDJobPostCell") as! JobPostCell
        if let m = self.mc{
            let jobPost = m.jobPosts[indexPath.row]
            cell.setJobPost(jobPost: jobPost)
        }
        return cell
    }
    
    
    
}
