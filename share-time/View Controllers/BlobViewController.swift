//
//  BlobViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/13/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import SwiftGifOrigin

class BlobViewController: UIViewController {
    
    var HPtext: UILabel!
    static var redBar: UILabel!
    static var HPnum: UILabel!
    var blackBorder : UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet var blobImage: UIImageView!
    
    var hp = 800
    let maxHP = 800
    var tiredTimer = Timer()
    var textField : UITextField!
    var label : UILabel!
    var user = PFUser.current()
    
    static let space = 200
    //var frameWidth: Int!
    
    static let frameWidth = Int(UIScreen.main.bounds.width)
    static var width = BlobViewController.frameWidth - space
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            Color.mediumBlue.cgColor, Color.lightGreen.cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
//        // Add animation of the gradient background
//        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
//        gradientChangeAnimation.duration = 5.0
//        gradientChangeAnimation.toValue = [
//            UIColor(red: 221/255, green: 214/255, blue: 243/255, alpha: 1).cgColor,
//            UIColor(red: 250/255, green: 172/255, blue: 168/255, alpha: 1).cgColor
//        ]
//        gradientChangeAnimation.fillMode = kCAFillModeForwards
//        gradientChangeAnimation.isRemovedOnCompletion = false
//        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        self.view.layer.insertSublayer(gradient, at: 0)
        
        // Get the gif of the blob
        blobImage.image = UIImage.gif(name: "defaultBlob")
        
        HPtext = UILabel(frame:CGRect(x:80, y:598, width: BlobViewController.width, height: 30))
        HPtext.text = "HP:"
        HPtext.font.withSize(25)
        view.addSubview(HPtext)
        
        BlobViewController.HPnum = UILabel (frame: CGRect(x:120+BlobViewController.width/2-30, y:598, width: 100, height:30))
        BlobViewController.HPnum.text = "800/800"
        BlobViewController.redBar = UILabel(frame:CGRect(x:120, y:598, width: BlobViewController.width, height: 30))
        blackBorder = UILabel(frame:CGRect(x:116, y:596, width: BlobViewController.width+8, height: 34))
        BlobViewController.redBar.backgroundColor = UIColor.red
        blackBorder.layer.cornerRadius = 8
        blackBorder.clipsToBounds = true
        blackBorder.layer.borderColor = UIColor.black.cgColor
        blackBorder.layer.borderWidth = 4
        
        view.addSubview(BlobViewController.redBar)
        view.addSubview(blackBorder)
        view.addSubview(BlobViewController.HPnum)
        
        HPTimer.startHPTimer()
        
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
        profileButton.layer.borderColor = UIColor.white.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(BlobViewController.updateBlobToSad), name: NSNotification.Name(rawValue: "updateBlobToSad"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BlobViewController.updateBlobToDefault), name: NSNotification.Name(rawValue: "updateBlobToDefault"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let imgUrlString = user!["imgUrl"] as? String
        let imgUrl = URL(string: imgUrlString!)!
        profileButton.af_setBackgroundImage(for: UIControlState.normal, url: imgUrl)
        profileButton.layer.cornerRadius = 22.5
        profileButton.layer.borderWidth = 2.0
        profileButton.layer.borderColor = UIColor.white.cgColor
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
    
    class func updateHPBar(hp: Int) {
        let barWidth: Double = Double(width) * Double(hp) / Double(800)
        
        redBar.frame = CGRect(x: 120, y: 598, width: barWidth, height: 30)
        HPnum.text = "\(String(hp))/800"
    }
    
    @objc func updateBlobToSad() {
        blobImage.image = UIImage(named: "sadBlob")
    }
    
    @objc func updateBlobToDefault(hp: Int) {
        blobImage.image = UIImage.gif(name: "defaultBlob")
    }
    
}
