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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
