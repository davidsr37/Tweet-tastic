//
//  UserTweetsVC.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/9/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

class UserTweetsVC : UIViewController, UITableViewDataSource {
  
  var networkController : NetworkController!
  var userID : String!
  var tweets : [Tweet]?

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
    self.tableView.estimatedRowHeight = 140
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.registerNib(UINib(nibName: "UserTweetsNib", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "USER_CELL")
    self.networkController.fetchTimelineForUser(self.userID, completionHandler: { (tweets, errorDescription) -> () in
      self.tweets = tweets
      self.tableView.reloadData()
    })
    
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
    if let tweets = self.tweets {
      return self.tweets!.count
    } else {
      return 0
    }
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("USER_CELL", forIndexPath: indexPath) as UserTweetCell
    let tweet = self.tweets![indexPath.row]
    cell.tweetText.text = tweet.text
    cell.tweetTime.text = tweet.tweetTime
  
    return cell
    
  }
  
}