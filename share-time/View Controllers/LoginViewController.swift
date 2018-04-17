//
//  LoginViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var userSignup: UIButton!
    @IBAction func userLogin(_ sender: Any) {
    }
    @IBOutlet weak var password: UITextField!
    
    let signUpUsernameErrorAlertController = UIAlertController(title: "Username Required", message: "Please enter username", preferredStyle: .alert)
    let signUpPasswordErrorAlertController = UIAlertController(title: "Password Required", message: "Please enter password", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
