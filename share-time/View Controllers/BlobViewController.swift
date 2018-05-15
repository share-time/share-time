//
//  BlobViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/13/18.
//  Copyright © 2018 share-time. All rights reserved.
///Users/godwin/code/CodePath/share-time/share-time/Base.lproj/Main.storyboard

import UIKit

class BlobViewController: UIViewController {
    
    @IBOutlet weak var hpLabel: UILabel!
    
    var hp = 800
    var tiredTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hpLabel.text = String(hp)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            self.performSegue(withIdentifier: "toSleepSegue", sender: nil)
        }
    }
    
    @objc func updateHp(){
        if (hp >= 0){
            hp = hp - 1
            hpLabel.text = String(hp)
        }
        print("updatingHp: \(hp)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSleepSegue"){
            let studyingViewController = segue.destination as! StudyingViewController
            studyingViewController.changeHp = { (hp: Int) -> () in
                self.hp = self.hp + 1
                self.hpLabel.text = String(self.hp)
            }
            //studyingViewController.resumeUpdateHpTimer = { () -> () in
            //   self.tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
            //}
            //tiredTimer.invalidate()
        }
    }
}
