//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/7/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "HwbSFgwdv8JoynWsluZJ8RXip"
let twitterConsumerSecret = "a03TVpEk4PEvgvcu7eZOnmstKUlN0El9J6DKpKFJZluW1Aw2Ii"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func postTweet(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let status = params["status"] as! String
        POST("1.1/statuses/update.json?status=\(status)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error: \(error)")
            completion(tweet: nil, error: error)
        }
            
    }
    
    func favoriteWithCompletionWithParams(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        let id = params["id"] as! String
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            //print("response: \(response)")
            completion(tweet: tweet, error: nil)
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error: \(error)")
            print(params["id"])
            completion(tweet: nil, error: error)
        }
    }
    
    func retweetWithCompletionWithParams(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        let id = params["id"] as! String
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
                completion(tweet: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
            print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: {
            (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            print("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting current user")
            })
            
        }) { (error: NSError!) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }

    }
}
