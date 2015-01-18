//
//  ViewController.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/5/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//
// Acknowledgement to "Portlandia" for "Put a bird on it"
// Many thanks to David at http://onthethirdfloordesign.blogspot.com/2011/03/put-bird-on-it.html for bird images

//Libraries
import UIKit

//Class
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  //Outlets
  @IBOutlet weak var tableView: UITableView!
  
  //Class Variables
  let networkController = NetworkController()
          //lazy for UI
  lazy var tweets = [Tweet]()
  
//VDL
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  //TABLEVIEW PROPERTIES
    
    //registering this class as DataSource for TableView
    self.tableView.dataSource = self
    
    
    //set cell from XIB layout file
    self.tableView.registerNib(UINib(nibName: "TweetCellNib", bundle: NSBundle.mainBundle()),forCellReuseIdentifier: "tweetcell")
    
    //register as delegate
    self.tableView.delegate = self
    
    //set dynamic cell dimensions, must first estimate size then cast AutomaticDimension property for row height
    self.tableView.estimatedRowHeight = 250
    self.tableView.rowHeight = UITableViewAutomaticDimension
    
    //make network call for method used in this VC
    self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      if errorString == nil {
        self.tweets = tweets!
        self.tableView.reloadData()
      } else {
        println("alas - network failure")
      }
        
    }
  }
  
  
  //animate view property
  override func viewDidAppear(animated: Bool) {
      
      super.viewDidAppear(animated)
  }
        
    // Do any additional setup after loading the view, typically from a nib.
  

  
//TABLEVIEW FUNCTIONS
  
  //initialize rows
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets.count
  }
  
  //initialize cells using indexPath [tables are arrays] and output cell
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    //cell dequeueReusable and properties as defined in TweetCell2 custom class
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetcell", forIndexPath: indexPath) as TweetCell2
    
    let tweet = self.tweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.nameLabel.text = tweet.username
    cell.tweetTime.text = tweet.tweetTime
    
    //checking for the image and if not there, calling our NetworkController method to make the network call for the image  ***Segue to persistence***
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> () in
        
      //fade animation
      //self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        cell.tweetViewImage.image = tweet.image
      })
      
      cell.tweetViewImage.image = tweet.image
    } else {
      cell.tweetViewImage.image = tweet.image
    }
    //method returns a cell, so we do that
    return cell
    
  }

  //row selection method of tableview using indexpath
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println(indexPath.row)  //shows us what indexpath int we touched
    
    
    //push the view and pass the network controller
    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEETD_VC") as TweetDetailVC
    tweetVC.tweet = self.tweets[indexPath.row]
    tweetVC.networkController = networkController
    self.navigationController?.pushViewController(tweetVC, animated: true)
  }
}