//
//  ProfileTableViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/22/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class ProfileTableViewController: UITableViewController {
    
    let user = PFUser.current()!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var xBarButton: UIBarButtonItem!
    
    let logOutAlertController = UIAlertController(title: "Logout Alert", message: "Do you want to log out?", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        //does nothing -> dismisses alert view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        let username = (user.object(forKey: "username") as? String)!
        let email = (user.object(forKey: "email") as? String)!
        
        usernameLabel.text = username
        emailLabel.text = email
        
        let imgUrlString = user["imgUrl"] as! String
        let imgUrl = URL(string: imgUrlString)!
        profileImageView.af_setImage(withURL: imgUrl)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 5.0
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        
        logOutAlertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
                BlobHP.teardown()
                //PFUser.logOutInBackground()
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)}
        ))
        logOutAlertController.addAction(cancelAction)
        
        addBarButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 1
        } else {
            return 0 
        }
    }
    @IBAction func onChangeProfileImage(_ sender: Any) {
        let imgCode = String(arc4random_uniform(UInt32.max))
        let userIconBaseURLString = "http://api.adorable.io/avatars/285/"
        let imgUrl = URL(string: userIconBaseURLString+imgCode+".png")!
        user["imgUrl"] = userIconBaseURLString+imgCode+".png"
        self.profileImageView.af_setImage(withURL: imgUrl)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width*0.5
        user.saveInBackground()
    }
    
    func addBarButton(){
        let xBarButton = UIBarButtonItem(title: "x", style: .plain, target: self, action: #selector(xBarButtonPressed(sender:)))
        navigationItem.setLeftBarButton(xBarButton, animated: false)
        self.xBarButton = xBarButton
    }
    
    @objc func xBarButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.present(logOutAlertController, animated: true, completion: nil)
    }
}
