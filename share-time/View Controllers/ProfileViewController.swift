//
//  ProfileViewController.swift
//  share-time
//
//  Created by Guanxin Li on 4/30/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
class ProfileViewController: UIViewController {

    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var personalImage: UIImageView!
    
    var xBarButton: UIBarButtonItem!
    
    let user = PFUser.current()!
    var username: String = ""
    var email: String = ""
    
    let noSaveAlertController = UIAlertController(title: "Username Required", message: "Please enter username", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    let logOutAlertController = UIAlertController(title:"Logout Alert", message:"Do you want to log out?", preferredStyle:.alert)
   /*
    let continueAction = UIAlertAction(title: "Continue", style: .default){ (action) in
        
        updateParseUser()
    }
 
    */
    
    /*
    @IBAction func save(_ sender: Any) {
        var changed = false
        
        if (username != nameText.text){
            user["username"] = nameText.text
            changed = true
        }
        if (email != emailText.text){
            user["email"] = emailText.text
            changed = true
        }
        
        if (changed){
            user.saveInBackground{ (success: Bool, error: Error?) -> Void in
                if (success){
                    
                } else {
                    print("wassup")
                }
            }
        }
    }
    */
    
    @IBAction func changePassWord(_ sender: Any) {
      self.performSegue(withIdentifier: "changePasswordSegue", sender: nil)
    }

    @IBAction func changePersonalImage(_ sender: Any) {
        let imgCode = String(arc4random_uniform(UInt32.max))
        let userIconBaseURLString = "http://api.adorable.io/avatars/285/"
        let imgUrl = URL(string: userIconBaseURLString+imgCode+".png")!
        user["imgUrl"] = userIconBaseURLString+imgCode+".png"
        self.personalImage.af_setImage(withURL: imgUrl)
        self.personalImage.layer.cornerRadius = self.personalImage.frame.width*0.5
        user.saveInBackground{ (success: Bool, error: Error?) -> Void in
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground()
        self.present(logOutAlertController,animated: true, completion: nil)
        /*
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = (user.object(forKey: "username") as? String)!
        email = (user.object(forKey: "email") as? String)!
        emailText.text = email
        nameText.text = username
        let imgUrlString = user["imgUrl"] as! String
        let imgUrl = URL(string: imgUrlString)!
        personalImage.af_setImage(withURL: imgUrl)
        addBarButton()
        
        logOutAlertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler:{
            action in self.performSegue(withIdentifier: "logoutSegue", sender: nil)}
        ))
        logOutAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        username = (user.object(forKey: "username") as? String)!
        email = (user.object(forKey: "email") as? String)!
        emailText.text = email
        nameText.text = username
    }

    func addBarButton(){
        let xBarButton = UIBarButtonItem(title: "x", style: .plain, target: self, action: #selector(xBarButtonPressed(sender:)))
        navigationItem.setLeftBarButton(xBarButton, animated: false)
        self.xBarButton = xBarButton
    }
    
    @objc func xBarButtonPressed(sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func updateParseUser() {
        let user = PFUser.current()
        user?.saveInBackground{ (success: Bool, error: Error?) -> Void in
        }
    }
}
