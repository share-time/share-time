//
//  HPTimer.swift
//  share-time
//
//  Created by Godwin Pang on 6/17/18.
//  Copyright © 2018 share-time. All rights reserved.
//
//  Self-written version of timer to facilitate easy reuse.
//  Needed for 3 timers:

import Foundation
import UIKit

class HPTimer{
    
    // Holds actual timer
    var timer = Timer()
    
    var studyHours = 5.0 {
        didSet {
            // code to set timerInterval based on studyHours
        }
    }
    
    // Interval in seconds elapsed between each call to onInterval.
    var timerInterval = 5.0 {
        didSet{
            restart()
        }
    }
    
    // Function closure that is to executed on each interval.
    var onInterval:(Timer) -> ()
    
    // Constructor.
    init(timerInterval: Double, onInterval: @escaping (Timer) -> ()){
        self.timerInterval = timerInterval
        self.onInterval = onInterval
    }
    
    // Starts timer.
    func start(){
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: onInterval)
    }
    
    // Stops timer.
    func stop(){
        timer.invalidate()
    }
    
    // Restarts timer.
    func restart(){
        stop()
        start()
    }
    
}
