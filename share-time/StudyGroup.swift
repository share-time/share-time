//
//  StudyGroup.swift
//  share-time
//
//  Created by Godwin Pang on 4/25/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class StudyGroup: PFObject, PFSubclassing {
    @NSManaged var members : [PFUser]
    @NSManaged var messages: [PFObject]
    @NSManaged var course: String
    @NSManaged var professor: String
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "StudyGroup"
    }
}
