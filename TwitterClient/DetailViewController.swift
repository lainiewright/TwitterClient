//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/16/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = tweet.author?.name
        
        descriptionLabel.text = tweet.text
        
        if let imageUrlString = tweet.author?.profileImageUrl {
            avatarImageView.setImageWithURL(NSURL(string: imageUrlString)!)
        }
        
        handleLabel.text = tweet.author?.screenname
        timeLabel.text = tweet.createdAtString
        
        if let likes = tweet.favoriteCount {
            likesLabel.text = likes.stringValue
        }
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletionWithParams(["id": tweet.id!]) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet.retweetCount = (tweet?.retweetCount)!
                self.retweetButton.imageView!.image = UIImage(named: "retweet_action_on_green")
            } else {
                print("error: \(error)")
            }
        }
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteWithCompletionWithParams(["id": tweet.id!]) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet.favoriteCount = (tweet?.favoriteCount)!
                self.likesLabel.text = tweet?.favoriteCount.stringValue
                self.favoriteButton.imageView?.image = UIImage(named: "like_action_on_red")
            } else {
                print("error: \(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
