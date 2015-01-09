//
//  TweetCell2.swift
//  TweetFellowsHW
//
//  Created by David Rogers on 1/5/15.
//  Copyright (c) 2015 David Rogers. All rights reserved.
//

import UIKit

class TweetCell2: UITableViewCell {
  
  
  @IBOutlet weak var tweetTime: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var tweetViewImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  

  
}
