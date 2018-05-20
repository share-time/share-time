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
    var changeHp:((Int) -> ())?
    var resumeUpdateHpTimer:(() -> ())?
    var deleteUpdateHpTimer:(() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        device.isProximityMonitoringEnabled = true
        if (device.isProximityMonitoringEnabled){
            NotificationCenter.default.addObserver(self, selector: #selector(StudyingViewController.proximityChanged), name: Notification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        device.isProximityMonitoringEnabled = true
        counter = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        device.isProximityMonitoringEnabled = false
        sleepTimer.invalidate()
    }

    @objc func proximityChanged(notification: Notification){
        if let device = notification.object as? UIDevice{
            print("\(device) detected!")
            print("proximityState: " + String(device.proximityState))
            if (device.proximityState){
                deleteUpdateHpTimer!()
                sleepTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StudyingViewController.updateSleepTimer), userInfo: nil, repeats: true)
            } else {
                print("Time interval: \(counter)")
                resumeUpdateHpTimer!()
                sleepTimer.invalidate()
            }
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func endSleep(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func updateSleepTimer(){
        if (counter < 800){
            counter = counter + 1
            changeHp!(counter)
            print("updateSleepTimer: \(counter)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
