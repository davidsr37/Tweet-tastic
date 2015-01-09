//
//  TweetDetailModel.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/8/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import Foundation

class TweetDetailModel {
  
  var text : String
  var username : String
  var imageURL : String
  var tweetTime : String
  init ( _ jsonDictionary : [String : AnyObject]) {  //init pulls jsonDict string items over as AnyObject and is returned as the text from the "text" field in the JSON file as a String
    self.text = jsonDictionary["text"] as String
    self.tweetTime = jsonDictionary["created_at"] as String
    let userDictionary = jsonDictionary["user"] as [String : AnyObject]
    self.username = userDictionary["name"] as String
    self.imageURL = userDictionary["profile_image_url"] as String
  
  
  
  
  
  
  
  
  }
}