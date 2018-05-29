//
//  MyJobApplicationsViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 29/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit
import PromiseKit

class MyJobApplicationsViewController: UIViewController {

    @IBOutlet weak var myJobApplicationsTableView: UITableView!
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly{
            self.mc.loadAppliedJobsIds()
        }.done{ t in
            if(t){
                let dp = DispatchGroup()
                self.mc.loadAppliedJobs(with: dp)
                dp.notify(queue: .main){
                    self.updateView()
                }
            }
        }.cauterize()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? JobPostDetailsViewController, let index = myJobApplicationsTableView.indexPathForSelectedRow?.row{
            view.jobPost = self.mc.jobsApplied[index]
            view.mc = self.mc
        }
    }
    
    private func updateView(){
        self.myJobApplicationsTableView.reloadData()
        self.myJobApplicationsTableView.endUpdates()
        print("View updated")
    }
}

extension MyJobApplicationsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mc.jobsApplied.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let jobPost = self.mc.jobsApplied[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RIDJobApplied")
        
        cell?.textLabel?.text = jobPost.title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let jobPost = self.mc.jobsApplied[indexPath.row]
        if(self.mc.appliedJobIds[jobPost.uid] == true){
            cell.backgroundColor = UIColor.init(red: 66/255, green: 207/255, blue: 103/255, alpha: 1)
        }
    }
    
}
