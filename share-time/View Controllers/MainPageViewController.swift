//
//  MainPageViewController.swift
//  share-time
//
//  Created by Guanxin Li on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class MainPageViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var personalImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    let user = PFUser.current()
    var studyGroups: [PFObject] = []
    var newStudyGroup: PFObject! //stores the study groups that the user has been added to
    var refresher: UIRefreshControl!
    
    let addNewStudyGroupAlertController = UIAlertController(title: "You have been added to a new study group", message: "Please confirm if you want to be added to the study group", preferredStyle: .alert)
    let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 125
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.darkText
        self.refresher.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refresher, at: 0)
        emailLabel.text = user?.email
        nameLabel.text = user?.username
        let iconURLString = user?["imgUrl"] as? String
        let iconURL = URL(string: iconURLString!)
        personalImage.af_setImage(withURL: iconURL!)
        user?.relation(forKey: "studyGroups").query().findObjectsInBackground{
            (studyGroups: [PFObject]?, error: Error?) -> Void in
            if error != nil {
                print("please dont print")
            } else {
                self.studyGroups = studyGroups!
                _ = self.getAllStudyGroups()
                self.tableView.reloadData()
            }
        }
        
        let ConfirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            PFUser.current()?.relation(forKey: "studyGroups").add(self.newStudyGroup)
            PFUser.current()?.saveInBackground{ (success: Bool, error: Error?) -> Void in
                if (success){
                    self.getStudyGroups()
                }
            }
        }
        addNewStudyGroupAlertController.addAction(CancelAction)
        addNewStudyGroupAlertController.addAction(ConfirmAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailLabel.text = user?.email
        nameLabel.text = user?.username
        let imgUrlString = user!["imgUrl"] as? String
        let imgUrl = URL(string: imgUrlString!)!
        personalImage.af_setImage(withURL: imgUrl)
        getStudyGroups()
        
    }
    
    func addNewStudyGroupToCurrentUser(studyGroup: PFObject)->(){
        user?.relation(forKey: "studyGroups").add(studyGroup)
        user?.saveInBackground()
    }
    
    //add study group to newstudygroup if it contains user and user's study groups does not contain said studygroup
    func searchStudyGroupForUser(studyGroup: PFObject)->(){
        studyGroup.relation(forKey: "members").query().findObjectsInBackground{
            (members: [PFObject]?, error: Error?) -> Void in
            if error != nil {
                print("please dont print")
            } else {
                let studyGroupMembers = members as! [PFUser]
                for member in studyGroupMembers{
                    if member.objectId == self.user!.objectId{
                        if !(self.tryIfArrayContainsPFObject(objectArray: self.studyGroups, findobject: studyGroup)){
                            self.newStudyGroup = studyGroup
                            if self.newStudyGroup != nil{
                                self.present(self.addNewStudyGroupAlertController, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //return true if contains
    func tryIfArrayContainsPFObject(objectArray: [PFObject], findobject: PFObject)->(Bool){
        var count = 0
        for object in objectArray{
            if findobject.objectId == object.objectId{
                count = count + 1
            }
        }
        
        return (count != 0)
    }
    
    func getStudyGroups() {
        user?.relation(forKey: "studyGroups").query().findObjectsInBackground{
            (studyGroups: [PFObject]?, error: Error?) -> Void in
            if error != nil {
                print("please dont print")
            } else {
                self.studyGroups = studyGroups!
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return studyGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyGroupCell", for: indexPath) as! StudyGroupCell
        cell.contentView.layer.cornerRadius = cell.layer.frame.height / 2
        let studyGroup = studyGroups[indexPath.row]
        cell.studyGroup = studyGroup

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let studyGroup = studyGroups[indexPath.row]
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.studyGroupName = studyGroup["name"] as! String
            chatViewController.studyGroup = studyGroup 
        }
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getStudyGroups()
        // Tell the refreshControl to stop spinning
        refresher.endRefreshing()
    }
    
    func getAllStudyGroups()->([PFObject]){
        var returnStudyGroups: [PFObject] = []
        let query = PFQuery(className: "StudyGroup")
        query.findObjectsInBackground(){ (findStudyGroups: [PFObject]?, error: Error?) -> Void in
            if findStudyGroups != nil{
                returnStudyGroups = findStudyGroups!
                print(returnStudyGroups)
            } else {
                print("WTF MAN")
            }
            for studyGroup in returnStudyGroups{
                self.searchStudyGroupForUser(studyGroup: studyGroup)
            }
        }
        return returnStudyGroups
    }
    
    

}
