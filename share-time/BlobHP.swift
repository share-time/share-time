//
//  BlobHP
//  share-time
//
//  Created by Godwin Pang on 5/19/18.
//  Copyright © 2018 share-time. All rights reserved.
//
//  Manages blob HP.

import Foundation
import UIKit
import Parse

class BlobHP {
    
    // NOTE
    //
    // Difference between class func and static func: class allows method to be
    // overwritten by subclasses.
    
    // HP levels and boundaries.
    static var hp = 800
    static let maxHP = 800
    static let minHP = 0
    
    // HP thresholds.
    static let updateBlobGifHp = 790
    
    static var interval = 5.0
    
    // Goals for study hours.
    static var studyHours = 6.0 {
        didSet {
            // TODO add code  for study hours to interval conversion
            // call setter for intervals for both timers
        }
    }
    
    // Timers for HP.
    static var hpIncreaseTimer = HPTimer(onIntervalClosure: BlobHP.increaseHP)
    static var hpDecreaseTimer = HPTimer(onIntervalClosure: BlobHP.decreaseHP)
    
    @objc static func increaseHP() {
        // Check if HP may be increased.
        if hp < maxHP {
            hp += 1
        } else {
            return
        }
        
        // Update HP bar.
        BlobViewController.updateHPBar(hp: hp)
        
        // Threshold check for blob image update.
        if hp > updateBlobGifHp {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBlobToDefault"), object: nil)
        }
    }
    
    @objc static func decreaseHP() {
        
        // Check if HP may be decreased.
        if hp > minHP {
            hp -= 1
        } else {
            return
        }
        
        // Update HP bar.
        BlobViewController.updateHPBar(hp: hp)
        
        // Threshold check for blob image update.
        if hp < updateBlobGifHp {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBlobToSad"), object: nil)
        }
    }
    
    static func updateStudyHours(hours: Double) {
        studyHours = hours
        
        // find algorithm that updates timer as intended.
        let updateFactor: Double = 1.0 / Double(hours)
        // hpChangeTimeInterval = 3.0 * updateFactor
    }
    
    static func swapTimers(){
        if hpIncreaseTimer.isRunning() {
            hpIncreaseTimer.stop()
            hpDecreaseTimer.start()
        } else if hpDecreaseTimer.isRunning() {
            hpDecreaseTimer.stop()
            hpIncreaseTimer.start()
        }
    }
    
    static func stopAllTimers() {
        hpIncreaseTimer.stop()
        hpDecreaseTimer.stop()
    }
    
    static func setup(completionHandler:@escaping (Bool) -> ()) {
        hpDecreaseTimer.start()
        let user = PFUser.current()
        let lastHP = user?["blobHP"] as? Int
        let logoutTimeString = user?["logoutTime"] as? String ?? ""
        
        if logoutTimeString == "" {
            hp = 800
        } else {
            let logoutTime = logoutTimeString.toDate()
            let timeElapsed = logoutTime.timeIntervalSinceNow
            hp = lastHP! + Int(timeElapsed / interval)
        }
        completionHandler(true)
    }
    
    static func teardown() {
        stopAllTimers()
        let logoutTime = Date()
        let user = PFUser.current()
        user?["logoutTime"] = logoutTime.toString()
        user?["blobHP"] = hp
        user?.saveInBackground { (success: Bool, _: Error?) -> Void in
            if success {
                PFUser.logOutInBackground()
            }
        }
    }
}
