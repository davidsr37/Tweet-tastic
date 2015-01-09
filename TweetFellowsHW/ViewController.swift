//
//  ViewController.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/5/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//
// Acknowledgement to "Portlandia" for "Put a bird on it"
// Many thanks to David at http://onthethirdfloordesign.blogspot.com/2011/03/put-bird-on-it.html for bird images

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  let networkController = NetworkController()
  
  lazy var tweets = [Tweet]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.dataSource = self
    self.tableView.registerNib(UINib(nibName: "TweetCellNib", bundle: NSBundle.mainBundle()),forCellReuseIdentifier: "tweetcell")
    
    self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      if errorString == nil {
        self.tweets = tweets!
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
      
        self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
          if errorString == nil {
            self.tweets = tweets!
            self.tableView.reloadData()
          } else {
            println("fail")
          }
        
        }
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
      
      super.viewDidAppear(animated)
  }
  
  
        
    // Do any additional setup after loading the view, typically from a nib.
  

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetcell", forIndexPath: indexPath) as TweetCell2
    let tweet = self.tweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.nameLabel.text = tweet.username
    cell.tweetTime.text = tweet.tweetTime
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> () in
      self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
      })
      
    } else {
      cell.tweetViewImage.image = tweet.image
    }
    return cell
}


  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println(indexPath.row)
    
    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEETD_VC") as TweetDetailVC
    tweetVC.tweet = self.tweets[indexPath.row]
    tweetVC.networkController = networkController
    self.navigationController?.pushViewController(tweetVC, animated: true)
  }
}