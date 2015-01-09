//
//  Tweet.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/5/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

//create tweet class pulling data from JSON file labelled "text" as String

class Tweet {
  var text : String
  var username : String
  var imageURL : String
  var image : UIImage?
  var tweetTime : String
  var favoriteCount : String?
  var userID : String
  
  
  init ( _ jsonDictionary : [String : AnyObject]) {  //init pulls jsonDict string items over as AnyObject and is returned as the text from the "text" field in the JSON file as a String
    self.text = jsonDictionary["text"] as String
    self.tweetTime = jsonDictionary["created_at"] as String
    let userDictionary = jsonDictionary["user"] as [String : AnyObject]
    self.username = userDictionary["name"] as String
    self.imageURL = userDictionary["profile_image_url"] as String

    self.userID = userDictionary["id_str"] as String
  
   // println(userDictionary) --removed to increase efficiency
    
    if jsonDictionary["in_reply_to_user_id"] is NSNull {
      
      
      println("nsnull")
    }
    
  }
  
  func updateWithInfo(infoDictionary : [String : AnyObject]) {
    let favoriteNumber = infoDictionary["favorite_count"] as Int
    self.favoriteCount = "\(favoriteNumber)"
  }
  
}