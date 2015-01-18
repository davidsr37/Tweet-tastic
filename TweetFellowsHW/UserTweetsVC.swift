//
//  UserTweetsVC.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/9/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

//Libraries
import UIKit

//class
class UserTweetsVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //Outlets
  
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var tableHeader: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var userLocale: UILabel!
  @IBOutlet weak var backgroundImage: UIImageView!
  
  //Class Variables
  var networkController : NetworkController!
  var userID : String!
  var tweets : [Tweet]?
  var tweet : Tweet!
  
  
  //VDL
  override func viewDidLoad() {
    super.viewDidLoad()
  
  


//TABLEVIEW PROPERTIES
    
    
    //registering this class as DataSource for Tableview
    self.tableView.dataSource = self
    
    //dynamic cell dimensions
    self.tableView.estimatedRowHeight = 250
    self.tableView.rowHeight = UITableViewAutomaticDimension
    
    //register as delegate
    self.tableView.delegate = self
    
    //Nibtastic
    self.tableView.registerNib(UINib(nibName: "TweetCellNib", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweetcell")
    
    //straightforward network call
    self.networkController.fetchTimelineForUser(self.userID, completionHandler: { (tweets, errorDescription) -> () in
        self.tweets = tweets
        self.tableView.reloadData()
      
    })
    
    //header
    self.userLocale.text = tweet?.locale
    self.userName.text = tweet?.username
    self.userImage.image = tweet?.image
    if tweet.backgroundImage == nil {
      self.networkController.fetchUserBackground(tweet, completionHandler: { (backgroundImage) -> () in
        
        self.backgroundImage.image = self.tweet.backgroundImage

      })
      
      self.backgroundImage.image = tweet.backgroundImage
    }
  }
  
  //animate tableView	UITableView!	0x01910a2c	0x01910a2cview property
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
  }

  
//TABLEVIEW FUNCTIONS
  
  //initialize rows
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
    if let tweets = self.tweets {
      return self.tweets!.count
    } else {
      return 0
    }
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetcell", forIndexPath: indexPath) as TweetCell2
    let tweet = self.tweets![indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.tweetTime.text = tweet.tweetTime
    cell.nameLabel.text = tweet.username
    
    
    
    //checking for the image and if not there, calling our NetworkController method to make the network call for the image  ***Segue to persistence***
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> () in
        
      //fade animation
      self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
      })
      cell.tweetViewImage.image = tweet.image
    } else {
      cell.tweetViewImage.image = tweet.image
    }
    
    //method returns a cell, so we fulfill that
    return cell
    
  }
  
  
 // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  
//  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    println(indexPath.row) //log indexpath touched
//   
//still working on infinite drilldown
//    //
//    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEETD_VC") as TweetDetailVC
//    tweetVC.networkController = networkController
//    tweetVC.tweet = self.twitter[indexPath.row]
//    
//    self.navigationController?.pushViewController(tweetVC, animated: true)
//  }
}