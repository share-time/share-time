//
//  Course.swift
//  share-time
//
//  Created by Godwin Pang on 4/25/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class Course: PFObject, PFSubclassing {
    @NSManaged var studyGroups : [StudyGroup]

    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Course"
    }
}
