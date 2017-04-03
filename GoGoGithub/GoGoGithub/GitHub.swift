//
//  GitHub.swift
//  GoGoGithub
//
//  Created by Erica Winberry on 4/3/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

typealias GitHubOAuthCompletion = (Bool) -> ()

enum GitHubAuthError: Error {
    case extractingCode
}

enum SaveOptions {
    case userDefaults
}

class GitHub {
    
    static let shared = GitHub()
    
    func oAuthRequestWith(parameters: [String: String]) {
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        print("Parameters String: \(parametersString)")
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)\(parametersString)") {
            
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
        }
    }
    
    func getCodeFrom(url: URL) throws -> String {
        
        guard let code = url.absoluteString.components(separatedBy: "=").last else { throw GitHubAuthError.extractingCode }
        
        return code
    }
    
    func tokenRequestFor(url: URL, saveOption: SaveOptions, completion: @escaping GitHubOAuthCompletion) {
        
        func complete(success: Bool) {
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        do {
            let code = try self.getCodeFrom(url: url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString) {
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    
                    if error != nil { complete(success: false) }
                    
                    guard let data = data else { complete(success: false); return }
                    
                    if let dataString = String(data: data, encoding: .utf8) {
                        print(dataString)
                        complete(success: true)
                    }
                    
                }).resume()
            }
            
        } catch {
            print(error)
            complete(success: false)
        }
        
        
        
    }
}
