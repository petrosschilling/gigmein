//
//  MyJobApplicationsViewController.swift
//  GigMeIn
//
//  Created by Petros Schilling on 29/5/18.
//  Copyright © 2018 Petros Schilling. All rights reserved.
//

import UIKit

class MyJobApplicationsViewController: UIViewController {

    @IBOutlet weak var myJobApplicationsTableView: UITableView!
    var mc: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}

extension MyJobApplicationsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
