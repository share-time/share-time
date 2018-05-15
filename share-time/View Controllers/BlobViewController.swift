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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hpLabel.text = String(hp)
        tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            studyingViewController.changeHp = { (hp: Int) -> Bool in
                self.hp = self.hp + 1
                self.hpLabel.text = String(self.hp)
                return true
            }
            studyingViewController.resumeUpdateHpTimer = { () -> Bool in
                self.tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
                return true
            }
            tiredTimer.invalidate()
        }
    }
}
