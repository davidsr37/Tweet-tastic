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
  func fetchHomeTimeline( completionHandler : ([Tweet]?, String?) -> ()) {
  
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
      if granted {
        let accounts = accountStore.accountsWithAccountType(accountType)
        if !accounts.isEmpty {
          let twitterAccount = accounts.first as ACAccount
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          twitterRequest.account = twitterAccount
          twitterRequest.performRequestWithHandler(){ (data, response, error) -> Void in
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
  
  func fetchImageForTweet(tweet : Tweet, completionHandler: (UIImage?) -> ()) {
        
    if let imageURL = NSURL(string: tweet.imageURL) {
          
      self.imageQueue.addOperationWithBlock({ () -> Void in
            
        if let imageData = NSData(contentsOfURL: imageURL) {
              tweet.image = UIImage(data: imageData)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(tweet.image)
              })
        
            }
          })
        }
    }
  
    func fetchTimelineForUser(userID : String, completionHandler: ([Tweet]?, String?) -> ()) {
      
      let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
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


