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

    @IBAction func onLogoutButton(_ sender: Any) {
        print("on sending logout")
        PFUser.logOutInBackground()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
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
