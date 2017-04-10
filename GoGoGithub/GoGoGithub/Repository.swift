//
//  Repository.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/4/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import Foundation

class Repository {
    
    let name: String
    let description: String?
    let language: String?
//    let url: String?
    
    let repoUrlString: String
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else { return nil }
        self.name = name
        
        
        
        if let repoDescription = json["description"] as? String, let repoLanguage = json["language"] as? String {
            self.description = repoDescription
            self.language = repoLanguage
        } else {
            self.description = "No description for this Repo."
            self.language = "No language found."
        }
        
        self.repoUrlString = json["html_url"] as? String ?? "https://www.github.com"
    }
}
