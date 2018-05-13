//
//  StudyingViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/12/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit

class StudyingViewController: UIViewController {
    
    let device = UIDevice.current
    var counter = 0.0
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        device.isProximityMonitoringEnabled = true
        if (device.isProximityMonitoringEnabled){
            //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.proximityChanged), name: Notification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
    }

    @objc func proximityChanged(notification: Notification){
        if let device = notification.object as? UIDevice{
            print("\(device) detected!")
            print("proximityState: " + String(device.proximityState))
            if (device.proximityState){
                //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
            } else {
                print("Time interval: \(counter)")
                timer.invalidate()
                counter = 0
            }
        }
    }
    
    @objc func updateTimer(){
        counter = counter + 1
        print(counter)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
