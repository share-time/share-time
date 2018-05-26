//
//  LoginViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet weak var usernameField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    var activeTextField : UITextField!
    
    let loginUsernameErrorAlertController = UIAlertController(title: "Username Required", message: "Please enter username", preferredStyle: .alert)
    let loginPasswordErrorAlertController = UIAlertController(title: "Password Required", message: "Please enter password", preferredStyle: .alert)
    //let loginErrorAlertController = UIAlertController(title: "Login Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.35))
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        self.view.insertSubview(view, at:0)
        gradient.colors = [
            UIColor(red: 186/255, green: 83/255, blue: 112/255, alpha: 1).cgColor,
            UIColor(red: 244/255, green: 226/255, blue: 216/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = [
            Color.darkPurpleColor.cgColor,
            Color.darkRedPinkColor.cgColor
        ]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        view.layer.insertSublayer(gradient, at: 0)
        headerLabel.textColor = UIColor.white
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = Color.paleBlue
        loginUsernameErrorAlertController.addAction(OKAction)
        loginPasswordErrorAlertController.addAction(OKAction)
        //loginErrorAlertController.addAction(self.OKAction)
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
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
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFIeldY:CGFloat! = self.activeTextField?.frame.origin.y
        
        if self.view.frame.origin.y >= 0 {
        // checking if the text field is really hiding behind the keyboard
            if editingTextFIeldY > keyboardY - 50 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFIeldY! - (keyboardY - 50)), width: self.view.bounds.width, height: self.view.bounds.height)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        if(usernameField.text?.isEmpty)!{
            present(loginUsernameErrorAlertController, animated: true)
        } else if(passwordField.text?.isEmpty)!{
            present(loginPasswordErrorAlertController, animated: true)
        } else {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    print(error)
                    let loginErrorAlertController = UIAlertController(title: "Login Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    loginErrorAlertController.addAction(self.OKAction)
                    self.present(loginErrorAlertController, animated: true)
                } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.navigationController?.parentPageboy?.navigationController?.view.endEditing(true)
    }
}
