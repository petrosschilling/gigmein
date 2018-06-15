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
    
    let logoutSegueID = "LogoutSegue"
    let employeeJobPostCellID = "EmployeeJobPostCellID"
    
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jobTableView.backgroundView = self.noItemsView
        self.jobTableView.setNeedsLayout()
        self.jobTableView.layoutIfNeeded()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? MyJobApplicationsViewController{
            view.mc = self.mc
        } else if let loadingVC = segue.destination as? LoadingViewController {
            loadingVC.mc = self.mc
        }
    }
    
    @IBAction func btnLogoutPressed(_ sender: Any) {
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
    
    @IBAction func btnRejectPressed(_ sender: Any) {
            if(self.mc.jobsToApply.count > 0){
                firstly{
                    self.mc.rejectJob()
                }.done{ b in
                      self.updateView()
                }.cauterize()
            }
    }
    
    @IBAction func btnAcceptPressed(_ sender: Any) {
        if(self.mc.jobsToApply.count > 0){
            firstly{
                self.mc.acceptJob()
            }.done{ b in
                self.updateView()
            }.cauterize()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.employeeJobPostCellID) as! EmployeeJobPostCell
        if let jobPost = self.mc.jobsToApply.first{
            cell.setJobPost(jobPost: jobPost)
        }
        return cell
    }
    
}
