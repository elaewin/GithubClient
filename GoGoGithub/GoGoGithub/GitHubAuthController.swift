//
//  GitHubAuthController.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/3/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (UserDefaults.standard.getAccessToken() != nil) {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.lightGray
        }
        // Do any additional setup after loading the view.
    }

    
    @IBAction func printTokenPressed(_ sender: UIButton) {
        if let token = UserDefaults.standard.getAccessToken() {
            print("Access Token is: \(token)")
        } else {
            print("No token found!")
        }
        
        
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let parameters = ["scope": "email,user"]
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
    }
}
