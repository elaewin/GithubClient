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

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (UserDefaults.standard.getAccessToken() != nil) {
            print("token is not nil.")
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.lightGray
        }

    }
    
    @IBAction func printTokenPressed(_ sender: UIButton) {
        if let token = UserDefaults.standard.getAccessToken() {
            print("Access Token is: \(token)")
        } else {
            print("No token found!")
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let parameters = ["scope": "email,user,repo"]
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
    }
}
