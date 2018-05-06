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
    @IBOutlet weak var joinStudyGroupButton: UIButton!
    var memberNum = 0
    
    let user = PFUser.current()
    
    var studyGroup: PFObject! {
        didSet {
            self.nameLabel.text = studyGroup.object(forKey: "name") as? String
            
            //get number of members
            studyGroup.relation(forKey: "members").query().findObjectsInBackground{
                (studyGroups: [PFObject]?, error: Error?) -> Void in
                if error != nil {
                    print("please dont print")
                } else {
                    self.memberNum = (studyGroups?.count)!
                    var memberNumString = String(describing: self.memberNum)
                    memberNumString += (self.memberNum == 1) ? " Member" : " Members"
                    self.memberCountLabel.text = memberNumString
                }
            }
            
            
            self.profLabel.text = studyGroup.object(forKey: "professor") as? String
            
            //check if user has already joined
            self.user?.relation(forKey: "studyGroups").query().findObjectsInBackground{
                (studyGroups: [PFObject]?, error: Error?) -> Void in
                //print("studyGroups: ")
                //print(studyGroups)
                //print(self.studyGroup)
                for studyGroup in studyGroups!{
                    if (studyGroup["name"] as? String == self.studyGroup["name"] as? String){
                        self.joinStudyGroupButton.isHidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func onJoinStudyGroup(_ sender: Any) {
        let studyGroupRelation = studyGroup?.relation(forKey: "members")
        studyGroupRelation?.add(user!)
        
        let userRelation = user?.relation(forKey: "studyGroups")
        userRelation?.add(studyGroup)
        
        
        studyGroup?.saveInBackground{ (success: Bool, error: Error?) -> Void in
            if (success){
                self.user?.saveInBackground{ (success: Bool, error: Error?) -> Void in
                    if (success){
                        self.joinStudyGroupButton.isHidden = true
                        self.memberNum = self.memberNum + 1
                        var memberNumString = String(describing: self.memberNum)
                        memberNumString += (self.memberNum == 1) ? " Member" : " Members"
                        self.memberCountLabel.text = memberNumString
                    } else {
                        print("i fucked up again")
                    }
                }
            } else {
                print(error?.localizedDescription as Any)
            }
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
