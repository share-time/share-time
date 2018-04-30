//
//  PublicStudyGroupCell.swift
//  share-time
//
//  Created by Godwin Pang on 4/16/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit

class PublicStudyGroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
