//
//  LoginViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let loginUsernameErrorAlertController = UIAlertController(title: "Username Required", message: "Please enter username", preferredStyle: .alert)
    let loginPasswordErrorAlertController = UIAlertController(title: "Password Required", message: "Please enter password", preferredStyle: .alert)
    //let loginErrorAlertController = UIAlertController(title: "Login Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 103/255, green: 62/255, blue: 48/255, alpha: 0.5).cgColor,
            UIColor(red: 53/255, green: 88/255, blue: 244/255, alpha: 0.5).cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        self.view.layer.addSublayer(gradient)
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = [
            UIColor(red: 53/255, green: 88/255, blue: 244/255, alpha: 0.5).cgColor,
            UIColor(red: 107/255, green: 70/255, blue: 196/255, alpha: 0.5).cgColor
        ]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        loginUsernameErrorAlertController.addAction(OKAction)
        loginPasswordErrorAlertController.addAction(OKAction)
        //loginErrorAlertController.addAction(self.OKAction)
        // Do any additional setup after loading the view.
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
            print("empty username")
        } else if(passwordField.text?.isEmpty)!{
            present(loginPasswordErrorAlertController, animated: true)
            print("empty password")
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
