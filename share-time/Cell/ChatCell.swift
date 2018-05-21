//
//  ChatCell.swift
//  share-time
//
//  Created by Guanxin Li on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {
    @IBOutlet var chatLeftConstraint: NSLayoutConstraint!
    @IBOutlet var chatLeftConstraintU: NSLayoutConstraint!
    @IBOutlet var chatRightConstraintU: NSLayoutConstraint!
    @IBOutlet var chatRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personalIconImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        for subview in self.contentView.subviews {
//            subview.removeFromSuperView
//        }
//    }
}
