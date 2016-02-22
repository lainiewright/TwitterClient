//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/9/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate: class {
    optional func tweetCellUserProfileImageTapped(cell: TweetCell, forTwitterUser user: User?)
}

class TweetCell: UITableViewCell {
    var index: Int!
    weak var delegate: TweetCellDelegate?
    
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
                self.favoriteButton.imageView?.image = UIImage(named: "like_action_on_red")
            } else {
                print("error: \(error)")
            }
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletionWithParams(["id": tweet.id!]) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet.retweetCount = (tweet?.retweetCount)!
                self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
                self.retweetButton.imageView?.image = UIImage(named: "retweet_action_on_green")
            } else {
                print("error: \(error)")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        descriptionLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: "imageViewTapped")
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageViewTapped() {
        delegate?.tweetCellUserProfileImageTapped?(self, forTwitterUser: tweet.author)
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
