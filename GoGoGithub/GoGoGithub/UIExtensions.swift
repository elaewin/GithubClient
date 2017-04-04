//
//  UIExtensions.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/4/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit

extension UIResponder {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
