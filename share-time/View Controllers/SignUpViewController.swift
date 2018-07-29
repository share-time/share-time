//
//  SignUpViewController.swift
//  share-time
//
//  Created by Jiayi Wang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    
    

    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmField: SkyFloatingLabelTextField!
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = Color.paleBlue
        self.view.backgroundColor = UIColor(red: 244/255, green: 226/255, blue: 216/255, alpha: 1)
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        // Set up the text field
        emailField.placeholder = "email"
        emailField.title = "email"
        emailField.tintColor = Color.darkPurpleColor // the color of the blinking cursor
        emailField.textColor = Color.darkGreyColor
        emailField.lineColor = Color.lightGreyColor
        emailField.selectedTitleColor = Color.darkPurpleColor
        emailField.selectedLineColor = Color.darkPurpleColor
        emailField.lineHeight = 2.0 // bottom line height in points
        emailField.selectedLineHeight = 2.0
        
        usernameField.placeholder = "username"
        usernameField.title = "username"
        usernameField.tintColor = Color.darkPurpleColor // the color of the blinking cursor
        usernameField.textColor = Color.darkGreyColor
        usernameField.lineColor = Color.lightGreyColor
        usernameField.selectedTitleColor = Color.darkPurpleColor
        usernameField.selectedLineColor = Color.darkPurpleColor
        usernameField.lineHeight = 2.0 // bottom line height in points
        usernameField.selectedLineHeight = 2.0
        
        passwordField.placeholder = "password"
        passwordField.title = "password"
        passwordField.tintColor = Color.darkPurpleColor // the color of the blinking cursor
        passwordField.textColor = Color.darkGreyColor
        passwordField.lineColor = Color.lightGreyColor
        passwordField.selectedTitleColor = Color.darkPurpleColor
        passwordField.selectedLineColor = Color.darkPurpleColor
        passwordField.lineHeight = 2.0 // bottom line height in points
        passwordField.selectedLineHeight = 2.0
        
        confirmField.placeholder = "confirm password"
        confirmField.title = "confirm password"
        confirmField.tintColor = Color.darkPurpleColor // the color of the blinking cursor
        confirmField.textColor = Color.darkGreyColor
        confirmField.lineColor = Color.lightGreyColor
        confirmField.selectedTitleColor = Color.darkPurpleColor
        confirmField.selectedLineColor = Color.darkPurpleColor
        confirmField.lineHeight = 2.0 // bottom line height in points
        confirmField.selectedLineHeight = 2.0
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
            self.alert(msg: "Please enter email", title: "Email Required", actionTitle: "OK")
        } else if (usernameField.text?.isEmpty)!{
            self.alert(msg: "Please enter username", title: "Username Required", actionTitle: "OK")
        } else if (passwordField.text?.isEmpty)!{
            self.alert(msg: "Please enter password", title: "Password Required", actionTitle: "OK")
        } else if(passwordField.text != confirmField.text){
            self.alert(msg: "Please enter again", title: "Confirm Password Failed", actionTitle: "OK")
        } else {
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    self.alert(msg: "\(error.localizedDescription)", title: "Signup Failed", actionTitle: "OK")
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
