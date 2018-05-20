//
//  BlobViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/13/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import FLAnimatedImage

class BlobViewController: UIViewController {
    
    var HPtext: UILabel!
    var redBar: UILabel!
    var HPnum: UILabel!
    var blackBorder : UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet var blobImage: FLAnimatedImageView!
    
    var hp = 800
    let maxHP = 800
    var tiredTimer = Timer()
    var textField : UITextField!
    var label : UILabel!
    var user = PFUser.current()
    
    let space = 120
    var frameWidth: Int!
    var width: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameWidth = Int(self.view.frame.size.width)
        width = frameWidth - space
        
        HPtext = UILabel(frame:CGRect(x:40, y:600, width: width, height: 30))
        HPtext.text = "HP:"
        HPtext.font.withSize(25)
        view.addSubview(HPtext)
        HPnum = UILabel (frame: CGRect(x:80+width/2-30, y:600, width: 100, height:30))
        HPnum.text = "800/800"
        redBar = UILabel(frame:CGRect(x:80, y:600, width: width, height: 30))
        blackBorder = UILabel(frame:CGRect(x:76, y:598, width: width+8, height: 34))
        redBar.backgroundColor = UIColor.red
        blackBorder.layer.cornerRadius = 8
        blackBorder.clipsToBounds = true
        blackBorder.layer.borderColor = UIColor.black.cgColor
        blackBorder.layer.borderWidth = 4
        
        view.addSubview(redBar)
        view.addSubview(blackBorder)
        view.addSubview(HPnum)
        
        tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        let imgUrlString = user!["imgUrl"] as? String
        let imgUrl = URL(string: imgUrlString!)!
        if profileButton == nil {
            print("profile is nil")
        }
        profileButton.af_setBackgroundImage(for: UIControlState.normal, url: imgUrl)
        profileButton.layer.cornerRadius = 22.5
        profileButton.layer.borderWidth = 2.0
        profileButton.layer.borderColor = UIColor.gray.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let imgUrlString = user!["imgUrl"] as? String
        let imgUrl = URL(string: imgUrlString!)!
        profileButton.af_setBackgroundImage(for: UIControlState.normal, url: imgUrl)
        profileButton.layer.cornerRadius = 22.5
        profileButton.layer.borderWidth = 2.0
        profileButton.layer.borderColor = UIColor.gray.cgColor
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
        if (hp > 0){
            hp = hp - 1
            
            let barWidth: Double = Double(width) * Double(hp) / Double(maxHP)

            redBar.frame = CGRect(x: 80, y: 600, width: barWidth, height: 30)
            HPnum.text = "\(String(hp))/800"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSleepSegue"){
            let studyingViewController = segue.destination as! StudyingViewController
            studyingViewController.changeHp = { (hp: Int) -> () in
                self.hp = self.hp + 1
                //self.hpLabel.text = String(self.hp)
            }
            studyingViewController.deleteUpdateHpTimer = { () -> () in
               self.tiredTimer.invalidate()
            }
            studyingViewController.resumeUpdateHpTimer = { () -> () in
                self.tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
            }
        }
    }
    
    
}
