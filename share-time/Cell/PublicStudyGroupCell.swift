//
//  PublicStudyGroupCell.swift
//  share-time
//
//  Created by Godwin Pang on 4/16/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class PublicStudyGroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    var studyGroup: PFObject! {
        didSet {
            self.nameLabel.text = studyGroup.object(forKey: "name") as? String
            let members = studyGroup.object(forKey: "members") as? [PFObject]
            let memberNum = members!.count
            var memberNumString = String(describing: memberNum)
            memberNumString += (memberNum == 1) ? " Member" : " Members"
            self.memberCountLabel.text = memberNumString
            self.profLabel.text = studyGroup.object(forKey: "professor") as? String
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
