//
//  SignUpViewController.swift
//  share-time
//
//  Created by Jiayi Wang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    let signUpUsernameErrorAlertController = UIAlertController(title: "Username Required", message: "Please enter username", preferredStyle: .alert)
    let signUpPasswordErrorAlertController = UIAlertController(title: "Password Required", message: "Please enter password", preferredStyle: .alert)
    let signUpEmailErrorAlertController = UIAlertController(title: "Email Required", message: "Please enter email", preferredStyle: .alert)
    let signUpConfirmErrorAlertController = UIAlertController(title: "Confirm Password Failed", message: "Please enter again", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpUsernameErrorAlertController.addAction(OKAction)
        signUpPasswordErrorAlertController.addAction(OKAction)
        signUpEmailErrorAlertController.addAction(OKAction)
        signUpConfirmErrorAlertController.addAction(OKAction)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text
        let imgCode = String(arc4random_uniform(UInt32.max))
        let userIconBaseURLString = "http://api.adorable.io/avatars/285/"
        newUser["imgUrl"] = userIconBaseURLString+imgCode+".png"
        if (emailField.text?.isEmpty)!{
            present(signUpEmailErrorAlertController, animated: true)
        } else if (usernameField.text?.isEmpty)!{
            present(signUpUsernameErrorAlertController, animated: true)
        } else if (passwordField.text?.isEmpty)!{
            present(signUpPasswordErrorAlertController, animated: true)
        } else if(passwordField.text != confirmField.text){
            present(signUpConfirmErrorAlertController, animated: true)
        } else {
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    let signUpErrorAlertController = UIAlertController(title: "Signup Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    signUpErrorAlertController.addAction(self.OKAction)
                    self.present(signUpErrorAlertController, animated: true)
                } else {
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func toSignIn(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
}
