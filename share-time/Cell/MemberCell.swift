//
//  MemberCell.swift
//  share-time
//
//  Created by Guanxin Li on 5/6/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class MemberCell: UICollectionViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberIconImage: UIImageView!
    
    var member: PFUser!{
        didSet{
            memberNameLabel.text = member.username
            memberIconImage.af_setImage(withURL: URL(string: (member["imgUrl"] as! String?)!)!)
        }
    }
}
