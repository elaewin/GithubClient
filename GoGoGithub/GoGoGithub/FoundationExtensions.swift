//
//  FoundationExtensions.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/3/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func getAccessToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else { return nil }
        
        return token
    }
    
    func save(accessToken: String) -> Bool {
        UserDefaults.standard.set(accessToken, forKey: "access_token")
        return UserDefaults.standard.synchronize()
    }
}

extension Date {
    
    var shortStyle: String {
        let shortFormatter = formatterWith(style: .short)
        return shortFormatter.string(from: self)
    }
    
    var mediumStyle: String {
        let mediumFormatter = formatterWith(style: .medium)
        return mediumFormatter.string(from: self)
    }
    
    var longStyle: String {
        let longFormatter = formatterWith(style: .long)
        return longFormatter.string(from: self)
    }
    
    private func formatterWith(style: DateFormatter.Style) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter
    }
    
    static func dateFromISO8601(_ string: String?) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: string)
    }

}

extension String {
    
    func validate() -> Bool {
        
        let pattern = "[^0-9a-z_-]"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: self.characters.count)
            let matches = regex.numberOfMatches(in: self, options: .reportCompletion, range: range)
            if matches > 0 { return false }
            
        } catch {
            return false
        }
        return true
    }
}






