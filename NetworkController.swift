//
//  NetworkController.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/7/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
  
  var twitterAccount : ACAccount?
  lazy var imageQueue = NSOperationQueue()
  
  init() {
    //blank init due to optional property
  }
  
//HOME TIMELINE API CALL METHOD
  func fetchHomeTimeline( completionHandler : ([Tweet]?, String?) -> ()) {
  
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
      if granted {
        let accounts = accountStore.accountsWithAccountType(accountType)
        if !accounts.isEmpty {
          self.twitterAccount = accounts.first as? ACAccount
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          twitterRequest.account = self.twitterAccount
          twitterRequest.performRequestWithHandler(){ (data, response, error) -> Void in
            //create switch based on response status code which is an Int
            switch response.statusCode {
            //set Int range for thumbs up status codes
            case 200...299:
              println("This is great!")
              //collect the objects from the JSON array in this case
              if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
                //set a variable for our Tweet model as a return of Array(s)
                var tweets = [Tweet]()
                //optional logic here for swifty nil handling
                for object in jsonArray {
                  //
                  if let jsonDictionary = object as? [String : AnyObject] {
                    let tweet = Tweet(jsonDictionary)
                    tweets.append(tweet)
                  }
                  
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(tweets, nil)
                })
              
            }
          case 300...599:
            println("This is bad - it's an error that may or may not be your fault")
            completionHandler(nil, "this is bad!")
          default:
            println("This is odd - default case fired")
              }
            }
          }
        }
      }
    }
  
//TWEET DETAIL NETWORK CALL METHOD
    func fetchInfoForTweet(tweetID : String, completionHandler : ([String : AnyObject]?, String?) -> ()) {
      
      let requestURL = "https://api.twitter.com/1.1/statuses/show.json?id=\(tweetID)"
      let url = NSURL(string : requestURL)
      let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url!, parameters: nil)
      request.account = self.twitterAccount
      request.performRequestWithHandler { (data, response, error) -> Void in
        if error == nil {
          switch response.statusCode {
          case 200...299:
            println("This is great!")
            
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(jsonDictionary, nil)
              })
            }
          default:
            println("odd default case")
          }
        }
      }
    }
//USER IMAGE NETWORK CALL METHOD
  func fetchImageForTweet(tweet : Tweet, completionHandler: (UIImage?) -> ()) {
    //grab url
    if let imageURL = NSURL(string: tweet.imageURL) {
      //setup seperate queue for UI efficiency
      self.imageQueue.addOperationWithBlock({ () -> Void in
        //turn url into NSData type
        if let imageData = NSData(contentsOfURL: imageURL) {
          //turn data in UIImage type
          tweet.image = UIImage(data: imageData)
          //return to main queue with image using completionHandler
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweet.image)
          })
        }
      })
    }
  }

//BACKGROUND IMAGE NETWORK CALL
  func fetchUserBackground(tweet : Tweet, completionHandler: (UIImage?) -> ()) {
    
    if let backgroundURL = NSURL(string: tweet.backgroundURL) {
      
      self.imageQueue.addOperationWithBlock({ () -> Void in
        
        if let backgroundData = NSData(contentsOfURL: backgroundURL) {
          tweet.backgroundImage = UIImage(data: backgroundData)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweet.backgroundImage)
          })
        }
      })
    }
  }

//USER TIMELINE DETAIL NETWORK CALL
  func fetchTimelineForUser(userID : String, completionHandler: ([Tweet]?, String?) -> ()) {
    
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userID)")
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL!, parameters: nil)
    request.account = self.twitterAccount
    request.performRequestWithHandler { (data, response, error) -> Void in
      if error == nil {
        switch response.statusCode {
        case 200...299:
          println("This is great!")
          
          if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
            var tweets = [Tweet]()
            for object in jsonArray {
              if let jsonDictionary = object as? [String : AnyObject] {
                let tweet = Tweet(jsonDictionary)
                tweets.append(tweet)
                }
              }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(tweets, nil)
              })
            }
        default:
          println("odd default case")
          }
        }
      }
    }
  }


