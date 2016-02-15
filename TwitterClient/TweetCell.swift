//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/9/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    var index: Int!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.author?.name
            descriptionLabel.text = tweet.text
            
            if let imageUrlString = tweet.author?.profileImageUrl {
                avatarImageView.setImageWithURL(NSURL(string: imageUrlString)!)
            }
            
            handleLabel.text = tweet.author?.screenname
            timeLabel.text = Tweet.timeAgoSinceDate(tweet.createdAt!)
            
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
        }
    }

    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteWithCompletionWithParams(["id": tweet.id!]) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet.favoriteCount = (tweet?.favoriteCount)!
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount)"
            } else {
                print("error: \(error)")
            }
        }
        //favoriteCountLabel.hidden = false
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletionWithParams(["id": tweet.id!]) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet.retweetCount = (tweet?.retweetCount)!
                self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            } else {
                print("error: \(error)")
            }
        }
        //retweetCountLabel.hidden = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if tweet.retweetCount > 0 {
//            retweetCountLabel.hidden = false
//        }
//        if tweet.favoriteCount > 0 {
//            favoriteCountLabel.hidden = false
//        }
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        descriptionLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
