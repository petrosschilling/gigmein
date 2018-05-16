//
//  EmployeeMainViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 11/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit
import FirebaseAuth
import PromiseKit

class EmployeeMainViewController: UIViewController {

    @IBOutlet weak var jobTableView: UITableView!
    @IBOutlet var noItemsView: UIView!
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jobTableView.backgroundView = noItemsView
        self.jobTableView.dataSource = self
        self.jobTableView.delegate = self
        
        firstly{
            self.mc.loadRejectedJobsIds()
        }.then{ b in
            self.mc.loadAppliedJobsIds()
        }.then{ b in
            self.mc.loadJobsToApply(tableView: self.jobTableView)
        }.done{ b in
            self.updateView()
        }.cauterize()
        
    }
    @IBAction func btnLogoutPressed(_ sender: Any) {
        self.mc.logoutUser()
        self.mc.nav.goToLoginStoryboard(viewRedirectionHandler: self, mc: self.mc)
    }
    
    @IBAction func btnRejectPressed(_ sender: Any) {
        self.mc.rejectJob()
        self.updateView()
    }
    
    @IBAction func btnAcceptPressed(_ sender: Any) {
        self.mc.acceptJob()
        self.updateView()
    }
    
    private func updateView(){
        self.jobTableView.reloadData()
        self.jobTableView.endUpdates()
    }
}


extension EmployeeMainViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.mc.jobsToApply.isEmpty){
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RIDEmployeeJobPostCell") as! EmployeeJobPostCell
        if let jobPost = self.mc.jobsToApply.first{
            cell.setJobPost(jobPost: jobPost)
        }
        return cell
    }
    
}
