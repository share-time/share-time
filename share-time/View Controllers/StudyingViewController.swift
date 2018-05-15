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
    var counter = 0
    var sleepTimer = Timer()
    var changeHp:((Int) -> (Bool))? // returns bool cuz I cant figure out how to write a closure returning Void

    override func viewDidLoad() {
        super.viewDidLoad()
        device.isProximityMonitoringEnabled = true
        if (device.isProximityMonitoringEnabled){
            NotificationCenter.default.addObserver(self, selector: #selector(StudyingViewController.proximityChanged), name: Notification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        device.isProximityMonitoringEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        device.isProximityMonitoringEnabled = false
    }

    @objc func proximityChanged(notification: Notification){
        if let device = notification.object as? UIDevice{
            print("\(device) detected!")
            print("proximityState: " + String(device.proximityState))
            if (device.proximityState){
                sleepTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StudyingViewController.updateTimer), userInfo: nil, repeats: true)
            } else {
                print("Time interval: \(counter)")
                sleepTimer.invalidate()
            }
        }
    }
    
    @IBAction func endSleep(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func updateTimer(){
        counter = counter + 1
        changeHp!(counter) // ignore the result unused warning
        print(counter)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
