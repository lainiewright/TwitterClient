//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/8/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        cell.index = indexPath.row

        cell.delegate = self
        
        return cell
    }
    
    func tweetCellUserProfileImageTapped(cell: TweetCell, forTwitterUser user: User?) {
        
        if let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController {
            // get the user from the cell here and assign it to `user` object in `profileViewController`
            profileViewController.user = user
            
            // push the `profileViewController` at the top of nav controller
            navigationController?.pushViewController(profileViewController, animated: true)
            
        }
    }
   
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.tweet = tweet
            
        } else if segue.identifier == "ComposeTweet" {
            let navController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navController.topViewController as! NewTweetViewController
            newTweetViewController.user = _currentUser
        }
    }

}
