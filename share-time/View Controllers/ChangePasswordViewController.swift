//
//  ChangePasswordViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/5/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import SkyFloatingLabelTextField

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    let signUpConfirmErrorAlertController = UIAlertController(title: "Passwords do not match", message: "Please enter again", preferredStyle: .alert)
    let signUpPasswordErrorAlertController = UIAlertController(title: "Incorrect Password", message: "Please re-enter password", preferredStyle: .alert)
    let signUpPasswordSuccessAlertController = UIAlertController(title: "Success", message: "Changed password successfully!", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    @IBOutlet weak var currentPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    var activeTextField : UITextField!
    
    let user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpConfirmErrorAlertController.addAction(OKAction)
        signUpPasswordErrorAlertController.addAction(OKAction)
        signUpPasswordSuccessAlertController.addAction(OKAction)
        // Do any additional setup after loading the view.
        
        self.title = "Password"
        
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        
        
        currentPasswordTextField.placeholder = "Current Password"
        currentPasswordTextField.title = "Current Password"
        currentPasswordTextField.tintColor = Color.overcastBlueColor // the color of the blinking cursor
        currentPasswordTextField.textColor = Color.darkGreyColor
        currentPasswordTextField.lineColor = Color.lightGreyColor
        currentPasswordTextField.selectedTitleColor = Color.overcastBlueColor
        currentPasswordTextField.selectedLineColor = Color.overcastBlueColor
        currentPasswordTextField.lineHeight = 1.0 // bottom line height in points
        currentPasswordTextField.selectedLineHeight = 2.0
        
        newPasswordTextField.placeholder = "New Password"
        newPasswordTextField.title = "New Password"
        newPasswordTextField.tintColor = Color.overcastBlueColor // the color of the blinking cursor
        newPasswordTextField.textColor = Color.darkGreyColor
        newPasswordTextField.lineColor = Color.lightGreyColor
        newPasswordTextField.selectedTitleColor = Color.overcastBlueColor
        newPasswordTextField.selectedLineColor = Color.overcastBlueColor
        newPasswordTextField.lineHeight = 1.0 // bottom line height in points
        newPasswordTextField.selectedLineHeight = 2.0
        
        
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.title = "Confirm Password"
        confirmPasswordTextField.tintColor = Color.overcastBlueColor // the color of the blinking cursor
        confirmPasswordTextField.textColor = Color.darkGreyColor
        confirmPasswordTextField.lineColor = Color.lightGreyColor
        confirmPasswordTextField.selectedTitleColor = Color.overcastBlueColor
        confirmPasswordTextField.selectedLineColor = Color.overcastBlueColor
        confirmPasswordTextField.lineHeight = 1.0 // bottom line height in points
        confirmPasswordTextField.selectedLineHeight = 2.0
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
    
    func clearPassword() {
        currentPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }

    @IBAction func onPasswordSave(_ sender: Any) {

        PFUser.logInWithUsername(inBackground: (self.user?.username!)!, password: self.currentPasswordTextField.text!) { (user: PFUser?, error: Error?) in
            if error != nil {
                self.present(self.signUpPasswordErrorAlertController, animated: true)
                self.clearPassword()
            } else {
                if (self.newPasswordTextField.text != self.confirmPasswordTextField.text){
                    self.present(self.signUpConfirmErrorAlertController, animated: true)
                    self.clearPassword()
                } else {
                    user?.password = self.newPasswordTextField.text
                    user?.saveInBackground{ (success: Bool, error: Error?) -> Void in
                        if (success){
                            self.present(self.signUpPasswordSuccessAlertController, animated: true)
                            if let navController = self.navigationController{
                                navController.popViewController(animated: true)
                            }
                            self.clearPassword()
                        } else {
                            print("could not save password")
                        }
                    }
                }
            }
        }
    }
    
}

