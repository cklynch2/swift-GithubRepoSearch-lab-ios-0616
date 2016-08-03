//
//  ReposTableViewController.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    var starController = UIAlertController()
    var unstarController = UIAlertController()
    var searchController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    // When a cell in the table view is selected, toggle the starred status and display a UIAlertController saying either "You just starred REPO NAME" or "You just unstarred REPO NAME".
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRepo = self.store.repositories[indexPath.row]
        configureStarAlertControllers(selectedRepo.fullName)
        
        store.toggleStarStatusForRepository(selectedRepo) { (toggleStar) in
            if toggleStar {
                self.presentViewController(self.starController, animated: true, completion: nil)
            } else if !toggleStar {
                self.presentViewController(self.unstarController, animated: true, completion: nil)
            }
        }
    }
    
    
    func configureStarAlertControllers(repoName: String) {
        starController = UIAlertController(title: "⭐️STAR⭐️", message: "You just starred \(repoName).", preferredStyle: .Alert)
        starController.accessibilityLabel = "You just starred REPO NAME"
        addDismissActionToAlert(starController)
        
        unstarController = UIAlertController(title: "💔UNSTAR💔", message: "You just unstarred \(repoName).", preferredStyle: .Alert)
        unstarController.accessibilityLabel = "You just unstarred REPO NAME"
        addDismissActionToAlert(unstarController)
    }
    
    
    func addDismissActionToAlert(alert: UIAlertController) {
        let okStarAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okStarAction)
    }
    
    
    func configureSearchAlertController() {
        searchController = UIAlertController(title: "🔍Search Repositories🔎", message: "Type your search parameters below.", preferredStyle: .Alert)
        
        // Note: Action buttons get added from left to right in the alert controller. We want the cancel button on the left, so do this first:
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            self.searchController.dismissViewControllerAnimated(true, completion: nil)
        }
        searchController.addAction(cancelAction)
        
        searchController.addTextFieldWithConfigurationHandler { (searchField) in
        // No textfield configuration necessary.
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .Default, handler:{ (action) in
            let searchField = self.searchController.textFields![0]
            if let search = searchField.text {
                GithubAPIClient.repositorySearch = search
                print(search)
                
                self.store.searchRepositoriesWithCompletion {
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.tableView.reloadData()
                    })
                }
            }
        })
        searchController.addAction(searchAction)
    }
    
    
    @IBAction func searchTapped(sender: AnyObject) {
        configureSearchAlertController()
        self.presentViewController(self.searchController, animated: true, completion: nil)
    }
    

}
