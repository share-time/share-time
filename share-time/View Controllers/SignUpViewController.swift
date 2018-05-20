//
//  SignUpViewController.swift
//  share-time
//
//  Created by Jiayi Wang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate{
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
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpUsernameErrorAlertController.addAction(OKAction)
        signUpPasswordErrorAlertController.addAction(OKAction)
        signUpEmailErrorAlertController.addAction(OKAction)
        signUpConfirmErrorAlertController.addAction(OKAction)
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFIeldY:CGFloat! = self.activeTextField?.frame.origin.y
        
        if self.view.frame.origin.y >= 0 {
            // checking if the text field is really hiding behind the keyboard
            if editingTextFIeldY > keyboardY - 60 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFIeldY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
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
