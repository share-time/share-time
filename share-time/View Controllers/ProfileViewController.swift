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
    
    let user = PFUser.current()!
    var username: String = ""
    var email: String = ""
    
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
                    print("WOOOO")
                    print("emailText.text: "+self.emailText.text!)
                    print(self.user["email"])
                    print("nameText.text: "+self.nameText.text!)
                    print(self.user["username"])
                } else {
                    print("wassup")
                }
            }
        }
    }
    
    @IBAction func changePassWord(_ sender: Any) {
      self.performSegue(withIdentifier: "changePasswordSegue", sender: nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = (user.object(forKey: "username") as? String)!
        email = (user.object(forKey: "email") as? String)!
        emailText.text = email
        nameText.text = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
