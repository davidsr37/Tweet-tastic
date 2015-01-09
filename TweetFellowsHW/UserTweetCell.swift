//
//  UserTweetCell.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/9/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

class UserTweetCell : UITableViewCell  {
  
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var tweetTime: UILabel!
  @IBOutlet weak var favsCount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
