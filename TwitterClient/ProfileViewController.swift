//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Lainie Wright on 2/21/16.
//  Copyright © 2016 lainiewright. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!

    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = user.name
        handleLabel.text = user.screenname
        
        if let imageUrl = user.profileImageUrl {
            profileImageView.setImageWithURL(NSURL(string: imageUrl)!)
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
