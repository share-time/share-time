//
//  ChatViewController.swift
//  share-time
//
//  Created by Guanxin Li on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import PKHUD

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let emptyMessageAlertController = UIAlertController(title: "Error", message: "Unable to send blank message", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    @IBOutlet weak var bottomContraints: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var activeTextField : UITextField!
    var chatMessage: [PFObject]? = []
    var refresher: UIRefreshControl!
    var studyGroupName: String!
    var studyGroup: PFObject!
    var members: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        messageTextField.delegate = self
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.darkText
        self.refresher.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refresher, at: 0)
        tableView.separatorStyle = .none
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        emptyMessageAlertController.addAction(OKAction)
        // Keyboard stuff
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        if let chatMessage = chatMessage {
            return chatMessage.count
        } else {
            return 0
        }
    }
    
    @objc func onTimer() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.whereKey("studyGroupName", equalTo: studyGroupName)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.chatMessage = posts
                self.tableView.reloadData()
            } else {
                print("Problem refreshing message: \(error!.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.personalIconImage.isHidden = false
        cell.usernameLabel.isHidden = false
        cell.bubbleView.layer.cornerRadius = 10
        cell.bubbleView.clipsToBounds = true
        cell.bubbleView.backgroundColor = UIColor.lightGray
       
        //cell.bubbleView.addConstraint(cell.chatLeftConstraint)
        
        //cell.chatLeftConstraint.constant = 15
        //cell.chatRightConstraint = NSLayoutConstraint(item: cell, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 15.0)
        cell.personalIconImage.clipsToBounds = true
        let messages = chatMessage?[(chatMessage?.count)! - indexPath.row - 1]
        if let msgString = messages?["text"] as? String {
            cell.messageLabel.text = msgString
        }
        if let user = messages?["user"] as? PFUser {
            if (user.username == PFUser.current()?.username) {
                cell.iconTop.isActive = false
                cell.iconLeading.isActive = false
                cell.chatRightConstraint.isActive = false
                cell.chatLeftConstraint.isActive = false
                cell.chatLeftConstraintU.isActive = true
                cell.chatRightConstraintU.isActive = true
                cell.personalIconImage.isHidden=true
                cell.usernameLabel.isHidden=true
//                cell.chatLeftConstraint.constant = 200
//                cell.chatRightConstraint.constant = 15
                cell.bubbleView.backgroundColor = UIColor(red:0.02, green:0.47, blue:0.98, alpha:1.0)
                cell.messageLabel.textColor = UIColor.white
//                cell.contentView.layoutIfNeeded()
//                cell.chatRightConstraint = NSLayoutConstraint(item: cell, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 15.0)
//                cell.chatLeftConstraint = NSLayoutConstraint(item: cell, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .leadingMargin, multiplier: 1.0, constant: 100.0)
//
//                cell.bubbleView.rightAnchor.constraint(equalTo: cell.rightAnchor)
//                print ("After changing, the left constaints is" + String(Float(cell.chatLeftConstraint.constant)))
//                print ("The right constaints is" + String(Float(cell.chatRightConstraint.constant)))
//                cell.contentView.layoutIfNeeded()
                
            }
           else{
                cell.iconTop.isActive = true
                cell.iconLeading.isActive = true
                cell.chatLeftConstraintU.isActive = false
                cell.chatRightConstraintU.isActive = false
                cell.chatRightConstraint.isActive = true
                cell.chatLeftConstraint.isActive = true
                cell.messageLabel.textColor = UIColor.black
            }
            //print("The user is: \(user)")
            
            cell.usernameLabel.text = user.username
            
            let imgUrlString = user["imgUrl"] as? String
            let imgUrl = URL(string: imgUrlString!)!
            cell.personalIconImage.af_setImage(withURL: imgUrl)
            
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        return cell
        //return cell
    }

    @IBAction func onSend(_ sender: UIButton) {
    if(messageTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.present(self.emptyMessageAlertController, animated: true)
        } else {
            let sendObject = PFObject(className: "Message")
            sendObject["text"] = messageTextField.text ?? ""
            sendObject["user"] = PFUser.current()
            sendObject["studyGroupName"] = studyGroupName
            sendObject.saveInBackground { (success, error) in
                if success {
                    print("The message was saved!")
                    self.messageTextField.text = ""
                } else if let error = error {
                    print("Problem saving message: \(error.localizedDescription)")
                }
            }
        }
    }
    @IBAction func toGroupInfoViewController(_ sender: Any) {
        studyGroup.relation(forKey: "members").query().findObjectsInBackground{
            (members: [PFObject]?, error: Error?) -> Void in
            if error == nil{
                self.members = members as! [PFUser]
                self.performSegue(withIdentifier: "toGroupInfoViewControllerSegue", sender: nil)
            }
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFIeldY:CGFloat! = self.activeTextField?.frame.origin.y
        
        if editingTextFIeldY > keyboardY - 80 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                self.bottomContraints.constant = keyboardSize.height + 60
            }, completion: nil)
        }
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.bottomContraints.constant = 13
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let groupInfoViewController = segue.destination as! GroupInfoViewController
        groupInfoViewController.studyGroup = studyGroup as! StudyGroup?
        groupInfoViewController.members = members as! [PFUser]
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        onTimer()
        // Tell the refreshControl to stop spinning
        refresher.endRefreshing()
    }

}
