//
//  SignUpViewController.swift
//  share-time
//
//  Created by Jiayi Wang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBAction func signUpButton(_ sender: Any) {
    }
    @IBOutlet weak var pwdConfirm: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userEmail: UITextField!
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
