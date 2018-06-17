//
//  hpTimer.swift
//  share-time
//
//  Created by Godwin Pang on 5/19/18.
//  Copyright © 2018 share-time. All rights reserved.
//
//  Manages timer that keeps track of blob HP.

import Foundation
import UIKit

class hpTimer{
    
    // NOTE
    //
    // Difference between class func and static func: class allows method to be
    // overwritten by subclasses.
    
    // HP levels and boundaries.
    static var hp = 800
    static let maxHP = 800
    static let minHP = 0
    
    // HP thresholds.
    static let updateBlobToSadHp = 790
    static let updateBlobToHappyHp = 0
    
    // Goals for study hours.
    static var studyHours: Float = 6
    
    // TODO CHANGE THIS SHITTY ASS NAME
    static var isIncrease = false
    
    
    // Timer interval.
    static var hpChangeTimeInterval:Double = 1 {
        // Restarts timer upon changing intervals.
        didSet{
            restartHPTimer()
        }
    }
    
    // Timer for HP.
    static var hpTimer = Timer()
    static var hpDecreaseTimer = Timer
    
    
    // Initializes new timer to start it.
    static func startHPTimer(){
        hpTimer = Timer.scheduledTimer(timeInterval: hpChangeTimeInterval, target: self, selector: #selector(HPTimer.updateHP), userInfo: nil, repeats: true)
    }

    // Invalidates timer to stop it.
    static func stopHPTimer(){
        hpTimer.invalidate()
    }
    
    // Restarts timer.
    static func restartHPTimer(){
        HPTimer.stopHPTimer()
        HPTimer.startHPTimer()
    }
    
    // Update
    @objc static func updateHP(){
        if (HPTimer.isIncrease){
            increaseHP()
        } else {
            decreaseHP()
        }
    }
    
    @objc static func increaseHP(){
        
        // Check if HP may be increased.
        if (hp < maxHP){
            hp = hp + 1
        } else {
            return
        }
        
        // Update HP bar.
        BlobViewController.updateHPBar(hp: hp)
        
        // Threshold check for blob image update.
        if (hp > updateBlobToSadHp) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBlobToDefault"), object: nil)
        }
    }
    
    @objc static func decreaseHP(){
        
        // Check if HP may be decreased.
        if (hp > minHP){
            hp = hp - 1
        } else {
            return
        }
        
        // Update HP bar.
        BlobViewController.updateHPBar(hp: hp)
        
        // Threshold check for blob image update.
        if (hp < updateBlobToSadHp) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBlobToSad"), object: nil)
        }
    }
    
    static func updateStudyHours(hours: Float){
        studyHours = hours
        
        // TODO find algorithm that updates timer as intended.
        let updateFactor:Double = 1.0/Double(hours)
        hpChangeTimeInterval = 3.0 * updateFactor
    }
}
