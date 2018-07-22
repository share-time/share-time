//
//  HPTimer.swift
//  share-time
//
//  Created by Godwin Pang on 6/17/18.
//  Copyright © 2018 share-time. All rights reserved.
//
//  Self-written version of timer to facilitate easy reuse.
//  Needed for 2 timers:

import Foundation
import UIKit

class HPTimer {
    
    // Holds actual timer
    private var timer = Timer()

    // Interval in seconds elapsed between each call to onInterval.
    private var interval = 5.0 {
        didSet {
            restart()
        }
    }
    
    // Closure that is to be executed on each interval.
    var onIntervalClosure: () -> Void
    
    // Constructor.
    init(onIntervalClosure: @escaping () -> Void) {
        self.onIntervalClosure = onIntervalClosure
    }
    
    // Starts timer.
    func start() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.onInterval), userInfo: nil, repeats: true)
    }
    
    // Stops timer.
    func stop() {
        timer.invalidate()
    }
    
    // Actual function called by timer on each interval.
    @objc func onInterval() {
        self.onIntervalClosure()
    }
    
    // Check if timer is running
    func isRunning() -> Bool {
        return timer.isValid
    }
    
    // Set interval of timer.
    func setInterval(interval: Double) {
        self.interval = interval
        self.restart()
    }
    
    // Restarts timer.
    func restart() {
        stop()
        start()
    }
    
}
