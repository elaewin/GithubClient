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
typealias GetReposCompletion = ([Repository]?) -> ()

enum GitHubAuthError: Error {
    case extractingCode(String)
    case gettingAccessToken(String)
}

enum SaveOptions {
    case userDefaults
}

class GitHub {
    
    static let shared = GitHub()
    
    private var session: URLSession
    private var components: URLComponents
    
    private init() {
        self.session = URLSession(configuration: .default)
        self.components = URLComponents()
        
        self.components.scheme = "https"
        self.components.host = "api.github.com"
    }
    
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
        
        guard let code = url.absoluteString.components(separatedBy: "=").last else { throw GitHubAuthError.extractingCode("Temporary code not found in string. See getCodeFrom(url:).") }
        
        return code
    }
    
    func tokenRequestFor(url: URL, saveOption: SaveOptions, completion: @escaping GitHubOAuthCompletion) {
        
        func returnToMainWith(success: Bool) {
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
                    
                    if error != nil { returnToMainWith(success: false) }
                    
                    guard let data = data else { returnToMainWith(success: false); return }
                    
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("My data string is: \(dataString)")
                        
                        if dataString.contains("access_token") {
                            
                            let components = dataString.components(separatedBy: "&")
                            print(components.count)
                            
                            for component in components {
                                if component.contains("access_token") {
                                    let token = component.components(separatedBy: "=").last!
                                    let success = UserDefaults.standard.save(accessToken: token)
                                    if success {
                                        print("Access token saved.")
                                        returnToMainWith(success: success)
                                    }
                                }
                            }
                        } else {
                            returnToMainWith(success: false)
                        }
                    }
                }).resume()
            }
        } catch {
            print(error)
            returnToMainWith(success: false)
        }
    }
    
    func getRepos(completion: @escaping GetReposCompletion) {
        
        func returnToMainWith(results: [Repository]?) {
            OperationQueue.main.addOperation {
                completion(results)
            }
        }
     
        self.components.path = "/user/repos"
        
        if let token = UserDefaults.standard.getAccessToken() {
            let tokenQueryItem = URLQueryItem(name: "access_token", value: token)
            self.components.queryItems = [tokenQueryItem]
        }
        
        let typeQueryItem = URLQueryItem(name: "type", value: "owner")
        self.components.queryItems?.append(typeQueryItem)
        
        guard let url = self.components.url else { returnToMainWith(results: nil); return }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            if error != nil { returnToMainWith(results: nil); return }
            
            if let data = data {
                var repositories = [Repository]()
                
                do {
                    if let rootJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        
                        print("JSON serialization succeeded.")
                        print("Name type: \(type(of: rootJSON[0]["name"]))")
                        
                        for repositoryJSON in rootJSON {
                            if let repo = Repository(json: repositoryJSON) {
                                print("Repo name: \(repo.name), Description: \(repo.description!), language: \(repo.language!)")
                                repositories.append(repo)
                            }
                        }
                        print(repositories.count)
                        returnToMainWith(results: repositories)
                    }
                } catch {
                    print("serialization failed.")
                }
            }
            
            
        }.resume()
    }
}
