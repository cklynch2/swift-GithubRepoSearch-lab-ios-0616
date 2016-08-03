//
//  ReposDataStore.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func searchRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.searchRepositoriesWithCompletion { (searchArray) in
            self.repositories.removeAll()
            for repository in searchArray {
                guard let repoDictionary = repository as? NSDictionary else { fatalError("Object in searchReposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)   
            }
            completion()
        }
    }
    
    // Given a GithubRepository object, check to see if it's starred or not and then either star or unstar the repo (ie, toggle the star on a given repository). Completion closure should accept Bool that is true if repo was just starred, false if it was just unstarred.
    func toggleStarStatusForRepository(repository: GithubRepository, completion: (Bool) -> ()) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (isStarred) in
            
            var toggleStar = Bool()
            if isStarred {
                GithubAPIClient.unstarRepository(repository.fullName, completion: {
                    // What needs to happen here, if anything?
                })
                toggleStar = false
                
            } else {
                GithubAPIClient.starRepository(repository.fullName, completion: {
                })
                toggleStar = true
            }
            completion(toggleStar)
        }
    }
    
    

}
