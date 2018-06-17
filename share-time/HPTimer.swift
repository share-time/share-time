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
    static let timer = Timer()
    
    // Interval in seconds elapsed between each call to onInterval.
    static var timerInterval: Double{
        didSet{
            restart()
        }
    }
    
    // Function closure that is to executed on each interval.
    static var onInterval:()?
    
    // Constructor.
    init(timerInterval: Double, onInterval: ()){
        self.timerInterval = timerInterval
        self.onInterval = onInterval
    }
    
    // Starts timer.
    static func start(){
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(HPTimer.onInterval), userInfo: nil, repeats: true)
    }
    
    // Stops timer.
    static func stop(){
        timer.invalidate()
    }
    
    // Restarts timer.
    static func restart(){
        stopTimer()
        startTimer()
    }
    
}
