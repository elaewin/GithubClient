//
//  GitHubAuthController.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/3/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func printTokenPressed(_ sender: UIButton) {
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let parameters = ["scope": "email,user"]
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
    }
}
