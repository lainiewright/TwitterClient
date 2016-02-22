//
//  Tweet.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/8/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String?
    var author: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoriteCount: NSNumber!
    var retweetCount: NSNumber!
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        favoriteCount = dictionary["favorite_count"] as! NSNumber
        retweetCount = dictionary["retweet_count"] as! NSNumber
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    class func tweetAsDictionary(dictionary: NSDictionary) -> Tweet {
        return Tweet(dictionary: dictionary)
    }
    
    class func timeAgoSinceDate(date:NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let momentsComponents = calendar.components([.Minute , .Hour , .Day , .WeekOfYear , .Month , .Year , .Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        if (momentsComponents.weekOfYear >= 1) {
            return "\(components.month)/\(components.day)/\(components.year)"
        } else if (momentsComponents.day >= 1) {
            return "\(momentsComponents.day)d"
        } else if (momentsComponents.hour >= 1) {
            return "\(momentsComponents.hour)h"
        } else if (momentsComponents.minute >= 1) {
            return "\(momentsComponents.minute)m"
        } else if (momentsComponents.second >= 2) {
            return "\(momentsComponents.second)s"
        } else {
            return "1s"
        }
        
    }

    
}
