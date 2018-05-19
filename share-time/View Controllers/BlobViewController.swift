//
//  BlobViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/13/18.
//  Copyright © 2018 share-time. All rights reserved.
///Users/godwin/code/CodePath/share-time/share-time/Base.lproj/Main.storyboard

import UIKit
import Parse
import FLAnimatedImage

class BlobViewController: UIViewController {
    
    var HPtext: UILabel!
    var redBar: UILabel!
    var blackBorder : UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet var blobImage: FLAnimatedImageView!
    
    var hp = 800
    var cgHP:CGFloat = 800
    let full:CGFloat = 800
    var tiredTimer = Timer()
    var textField : UITextField!
    var label : UILabel!
    var user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 120
        let width = self.view.frame.size.width - space
        
        HPtext = UILabel(frame:CGRect(x:40, y:600, width: width, height: 30))
        HPtext.text = "HP:"
        HPtext.font.withSize(25)
        view.addSubview(HPtext)
        redBar = UILabel(frame:CGRect(x:80, y:600, width: width, height: 30))
        blackBorder = UILabel(frame:CGRect(x:76, y:598, width: width+8, height: 34))
        redBar.backgroundColor = UIColor.red
        //redBar.layer.cornerRadius = 8
        blackBorder.layer.cornerRadius = 8
        blackBorder.clipsToBounds = true
        //redBar.clipsToBounds = true
        blackBorder.layer.borderColor = UIColor.black.cgColor
        blackBorder.layer.borderWidth = 4
        
        view.addSubview(redBar)
        view.addSubview(blackBorder)
        
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
        //profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileButton.layer.cornerRadius = 22.5
        profileButton.layer.borderWidth = 2.0
        profileButton.layer.borderColor = UIColor.gray.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hpLabel.text = String(hp)
        let imgUrlString = user!["imgUrl"] as? String
        let imgUrl = URL(string: imgUrlString!)!
        profileButton.af_setBackgroundImage(for: UIControlState.normal, url: imgUrl)
        //profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
            hpLabel.text = String(hp)
            
            cgHP = cgHP - 1
            let space:CGFloat = 120
            let width = self.view.frame.size.width - space
            redBar.frame = CGRect(x: 80, y: 600, width: width*cgHP/full, height: 30)
            //redBar.frame = CGRectMake(40, 600, width*cgHP/full, 30)
           
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
            studyingViewController.deleteUpdateHpTimer = { () -> () in
               self.tiredTimer.invalidate()
            }
            studyingViewController.resumeUpdateHpTimer = { () -> () in
                self.tiredTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BlobViewController.updateHp), userInfo: nil, repeats: true)
            }
            //tiredTimer.invalidate()
        }
    }
    
    
}
