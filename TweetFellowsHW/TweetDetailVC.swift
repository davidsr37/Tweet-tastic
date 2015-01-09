//
//  TweetDetailVC.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/8/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

class TweetDetailVC : UIViewController {
  
  @IBOutlet weak var tweetTime: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var tweetFavs: UILabel!

  @IBOutlet weak var userButton: UIButton!
  
  var tweet : Tweet!
  var networkController : NetworkController!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.userButton.setBackgroundImage(self.tweet.image!, forState: .Normal)
    self.tweetText.text = tweet.text
    self.userName.text = tweet.username
    self.tweetTime.text = tweet.tweetTime
    if tweet.favoriteCount != nil {
      self.tweetFavs.text = ("Favs: \(tweet.favoriteCount)")
    } else {
    self.tweetFavs.text = ("Favs: 0")
    }
    self.networkController.fetchInfoForTweet(tweet.userID, completionHandler: { (infoDictionary, errorDescription) -> () in
     // println(infoDictionary)
      if errorDescription == nil {
        self.tweet.updateWithInfo(infoDictionary!)
        self.tweetFavs.text = self.tweet.favoriteCount
      }
    })
}
  
  @IBAction func toUserTweets(sender: AnyObject) {
    
    let userVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_VC") as UserTweetsVC
    userVC.networkController = self.networkController
    userVC.userID = self.tweet.userID
    self.navigationController?.pushViewController(userVC, animated: true)
    
  }
  
  
}


