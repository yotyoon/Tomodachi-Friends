//
//  RSSTableViewCell.swift
//  TOMODACHI
//
//  Created by Kei Fujisato on 10/23/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemPubDateLabel: UILabel!
    @IBOutlet weak var ItemTitleLabel: UILabel!
    @IBOutlet weak var ItemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
