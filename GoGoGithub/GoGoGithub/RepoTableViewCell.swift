//
//  RepoTableViewCell.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/4/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    
    @IBOutlet weak var repoLanguageLabel: UILabel!
    
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    
    var repo: Repository! {
        didSet {
            self.repoNameLabel.text = repo.name
            if repo.language != nil {
                self.repoLanguageLabel.text = "Language: \(String(describing: repo.language))"
            }
            if repo.description != nil {
                self.repoDescriptionLabel.text = "\(String(describing: repo.description))"
            }
        }
    }
    
}
