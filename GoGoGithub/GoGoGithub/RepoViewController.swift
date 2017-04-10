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
    
    var filterResults = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        setUpSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == RepoDetailViewController.identifier {
            segue.destination.transitioningDelegate = self
        }
    }
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "RepoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: RepoTableViewCell.identifier)
    }
    
    func setUpSearchBar() {
        self.searchBar.delegate = self
    }

    func update() {
        GitHub.shared.getRepos { (repositories) in
            for repo in repositories! {
                self.allRepos.append(repo)
            }
        }
    }
    
    //MARK: Actions
}


//MARK: Extensions

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.text != "" {
            return filterResults.count
        } else {
            return allRepos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        
        var currentRepo: Repository
        
        if searchBar.text != "" {
            currentRepo = filterResults[indexPath.row]
        } else {
            currentRepo = allRepos[indexPath.row]
        }
        
        cell.repo = currentRepo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.lowercased()
        if text != "" {
            filterResults = self.allRepos.filter { $0.name.lowercased().contains(text) }
        } else {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension RepoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTransition(duration: 1.0)
        
    }
}






