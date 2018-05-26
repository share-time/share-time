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
    
    let logOutAlertController = UIAlertController(title:"Logout Alert", message:"Do you want to log out?", preferredStyle:.alert)
    let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
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
        
        logOutAlertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler:{
            action in
                PFUser.logOutInBackground()
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)}
        ))
        logOutAlertController.addAction(CancelAction)
        
        addBarButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        } else if (section == 1){
            return 3
        } else if section == 2{
            return 2
        } else if section == 3{
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
    
    @objc func xBarButtonPressed(sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        self.present(logOutAlertController, animated: true, completion: nil)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
