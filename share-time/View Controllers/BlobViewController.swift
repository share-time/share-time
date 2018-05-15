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
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hpLabel.text = String(hp)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSleepSegue"){
            let studyingViewController = segue.destination as! StudyingViewController
            studyingViewController.changeHp = { (hp: Int) -> Bool in
                self.hp = self.hp + 1
                self.hpLabel.text = String(self.hp)
                return true
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
