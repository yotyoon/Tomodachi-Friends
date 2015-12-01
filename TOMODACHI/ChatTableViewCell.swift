//
//  ChatTableViewCell.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/28/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
