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
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
//        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
//        let segue = UIStoryboardSegue(identifier: "ShowProfile", source: tweetsViewController, destination: profileViewController)
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
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: "imageViewTapped")
        cell.avatarImageView.addGestureRecognizer(tapGestureRecognizer)

        cell.delegate = self
        
        return cell
    }
    
    func tweetCellUserProfileImageTapped(cell: TweetCell, forTwitterUser user: User?) {
        self.performSegueWithIdentifier("ShowProfile", sender: cell)
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
        } else if segue.identifier == "ShowProfile" {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            let user = tweets![indexPath!.row].author
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = user
        }
    }

}
