//
//  RepoDetailViewController.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/5/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit
import SafariServices

class RepoDetailViewController: UIViewController {

    var repo: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func presentSafariViewControllerWith(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        let safariController = SFSafariViewController(url: url)
        
        self.present(safariController, animated: true, completion: nil)
        
        
    }
    
    func presentWebViewControllerWith(urlString: String) {
        
        let webController = WebViewController()
        webController.url = urlString
        
        self.present(webController, animated: true, completion: nil)
    }

    
    //MARK: Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func moreDetailsButtonPressed(_ sender: UIButton) {
        guard let repo = repo else { return }
//        presentSafariViewControllerWith(urlString: repo.repoUrlString)
        
        presentWebViewControllerWith(urlString: repo.repoUrlString)
    }
    
    
}
