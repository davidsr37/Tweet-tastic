//
//  Tweet.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/5/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

//create tweet class pulling data from JSON file, set class variables that will be associated with each piece of data on the array

class Tweet {
  var text : String
  var username : String
  var imageURL : String
  var image : UIImage?
  var tweetTime : String
  var favoriteCount : String?
  var userID : String
  var locale : String
  var backgroundURL : String
  var backgroundImage : UIImage?
  
  
  init ( _ jsonDictionary : [String : AnyObject]) {  //this key init pulls jsonDict string items over as AnyObject and is returned as the text from the "text" field in the JSON file as a String
    
    //start parsing out as properties
    self.text = jsonDictionary["text"] as String
    self.tweetTime = jsonDictionary["created_at"] as String
    
    //set a variable to drill deeper in to the dictionary
    let userDictionary = jsonDictionary["user"] as [String : AnyObject]
    //use that variable to pull the next layer
    self.username = userDictionary["name"] as String
    self.imageURL = userDictionary["profile_image_url"] as String
    self.userID = userDictionary["id_str"] as String
    self.locale = userDictionary["location"] as String
    self.backgroundURL = userDictionary["profile_background_image_url_https"] as String
    
    // to see it in the log
   // println(userDictionary)
    
    if jsonDictionary["in_reply_to_user_id"] is NSNull {
      
      
      println("nsnull")
      //this showed us how to see if a tweet was a retweet
    }
    
  }
//METHODS
 //a method to call when a refresh of the favorites count is indicated
  func updateWithInfo(infoDictionary : [String : AnyObject]) {
    
    //assigns a variable for the Int that it is
    var favoriteNumber = infoDictionary["favorite_count"] as Int
    
    //
    self.favoriteCount = "\(favoriteNumber)"
  }
  
}