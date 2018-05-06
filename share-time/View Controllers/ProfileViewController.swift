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

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var personalImage: UIImageView!
    
    let user = PFUser.current()!
    var username: String = ""
    var email: String = ""
    let noSaveAlertController = UIAlertController(title: "Username Required", message: "Please enter username", preferredStyle: .alert)
    let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    let SaveAction = UIAlertAction(title: "Save", style: .default){ (action) in
        updateParseUser()
    }
    
    
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
    
    @IBAction func changePassWord(_ sender: Any) {
      self.performSegue(withIdentifier: "changePasswordSegue", sender: nil)
    }

    @IBAction func changePersonalImage(_ sender: Any) {
        let imgUrl = String(arc4random_uniform(UInt32.max))
        user["imgUrl"] = imgUrl
        let userIconBaseURLString = "http://api.adorable.io/avatars/285/"
        let usrPathUrlString = user["imgUrl"] as! String
        let iconURL = URL(string: userIconBaseURLString + usrPathUrlString + ".png")!
        personalImage.af_setImage(withURL: iconURL)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        print("disappearing bb")
        /*
        if(username != nameText.text || email != emailText.text){
            self.present(noSaveAlertController, animated: true)
        }
        */
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = (user.object(forKey: "username") as? String)!
        email = (user.object(forKey: "email") as? String)!
        emailText.text = email
        nameText.text = username
        let userIconBaseURLString = "http://api.adorable.io/avatars/285/"
        let usrPathUrlString = user["imgUrl"] as! String
        let iconURL = URL(string: userIconBaseURLString + usrPathUrlString + ".png")!
        personalImage.af_setImage(withURL: iconURL)
        noSaveAlertController.addAction(SaveAction)
        noSaveAlertController.addAction(CancelAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        username = (user.object(forKey: "username") as? String)!
        email = (user.object(forKey: "email") as? String)!
        emailText.text = email
        nameText.text = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func updateParseUser() {
        let user = PFUser.current()
        user?.saveInBackground{ (success: Bool, error: Error?) -> Void in
            if (success){
                
            } else {
                print("wassup")
            }
        }
    }
}
