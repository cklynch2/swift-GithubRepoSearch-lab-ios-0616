//
//  GithubAPIClient.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GithubAPIClient {
    
    static var repositorySearch = String()
   
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let parameters = ["client_id": Secrets.githubClientID, "client_secret": Secrets.githubClientSecret]
        
        Alamofire.request(.GET, "https://api.github.com/repositories", parameters: parameters)
            .responseJSON { response in
                
                if let responseArray = response.result.value as? NSArray {
                    completion(responseArray)
                }
        }
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        let headers = ["Authorization": Secrets.githubToken]
        
        Alamofire.request(.GET, "https://api.github.com/user/starred/\(fullName)", headers: headers)
            .responseJSON { response in
                if let httpResponse = response.response {
                    
                    let status = httpResponse.statusCode
                    
                    var isStarred = Bool()
                    if status == 204 {
                        isStarred = true
                    } else if status == 404 {
                        isStarred = false
                    } else {
                        print("Other status code: \(status)")
                    }
                    completion(isStarred)
                }
        }
    }
    
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let headers = ["Authorization": Secrets.githubToken, "Content-Length": "0"]
        
        Alamofire.request(.PUT, "https://api.github.com/user/starred/\(fullName)", headers: headers)
            .responseJSON { response in
                if let httpResponse = response.response {
                    
                    let status = httpResponse.statusCode
                    
                    if status == 204 {
                        print("Successfully starred this repo.")
                    }
                    completion()
                }
        }
    }
    
    
    class func unstarRepository(fullName: String, completion: () -> ()) {
        let headers = ["Authorization": Secrets.githubToken]
        
        Alamofire.request(.DELETE, "https://api.github.com/user/starred/\(fullName)", headers: headers)
            .responseJSON { response in
                if let httpResponse = response.response {
                    
                    let status = httpResponse.statusCode
                    
                    if status == 204 {
                        print("Successfully unstarred this repo.")
                    }
                    completion()
                }
        }
    }
    
    class func searchRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        
        // These parameters mean that the search results will be ordered from the most recent to the oldest repository I think...
        let parameters = [ "client_id": Secrets.githubClientID, "client_secret": Secrets.githubClientSecret]

        Alamofire.request(.GET, "https://api.github.com/search/repositories?q=\(repositorySearch)", parameters: parameters)
            .responseJSON { response in
                
                if let searchResponse = response.result.value as? NSDictionary {
                    if let searchArray = searchResponse["items"] as? NSArray {
                        completion(searchArray)
                    }
                } else {
                    print("Error casting searched repositories to NSArray.")
                }
        }
    }


}