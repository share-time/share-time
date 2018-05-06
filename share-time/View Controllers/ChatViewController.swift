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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var chatMessage: [PFObject]? = []
    var refresher: UIRefreshControl!
    var studyGroupName: String!
    var studyGroup: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.darkText
        self.refresher.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refresher, at: 0)
        tableView.separatorStyle = .none
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
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
        let messages = chatMessage?[indexPath.row]
        if let msgString = messages?["text"] as? String {
            cell.messageLabel.text = msgString
        }
        
        if let user = messages?["user"] as? PFUser {
            print("The user is: \(user)")
            cell.usernameLabel.text = user.username
            
            let imgUrlString = user["imgUrl"] as? String
            let imgUrl = URL(string: imgUrlString!)!
            cell.personalIconImage.af_setImage(withURL: imgUrl)
            if (user.username == PFUser.current()?.username) {
                cell.bubbleView.backgroundColor = UIColor(red:0.02, green:0.47, blue:0.98, alpha:1.0)
            }
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        return cell
    }

    @IBAction func onSend(_ sender: UIButton) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let groupInfoViewController = segue.destination as! GroupInfoViewController
        groupInfoViewController.studyGroup = studyGroup
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        onTimer()
        // Tell the refreshControl to stop spinning
        refresher.endRefreshing()
    }

}
