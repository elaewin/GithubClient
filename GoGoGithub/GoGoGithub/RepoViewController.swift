//
//  RepoViewController.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/4/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    var allRepos = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        
        update()
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }


    func update() {
        GitHub.shared.getRepos { (repositories) in
            for repo in repositories! {
                self.allRepos.append(repo)
            }
        }
    }
    
}

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
