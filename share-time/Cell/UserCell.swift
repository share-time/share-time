//
//  UserCell.swift
//  share-time
//
//  Created by Godwin Pang on 5/5/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class UserCell: UITableViewCell {
    
    //returns false if user has been removed (+) and true if user has been added (-)
    var onSelect:((PFUser) -> (Bool))?
    var user: PFUser!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var selectMemberButton: UIButton!
    
    
    @IBAction func onSelectUserAsMember(_ sender: Any) {
        let buttonText = onSelect!(user)
        if (buttonText){
            selectMemberButton.setTitle("+", for: .normal)
        } else {
            selectMemberButton.setTitle("-", for: .normal)
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
