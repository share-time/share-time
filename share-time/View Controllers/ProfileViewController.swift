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
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        print("on sending logout")
        PFUser.logOutInBackground()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func save(_ sender: Any) {
    }
    @IBAction func changePassWord(_ sender: Any) {
      self.performSegue(withIdentifier: "changePasswordSegue", sender: nil)
    }
    
    @IBOutlet weak var leave: UIButton!
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
