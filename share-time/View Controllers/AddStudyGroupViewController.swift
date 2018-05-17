//
//  AddStudyGroupViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class AddStudyGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var profTextField: UITextField!
    @IBOutlet weak var studyGroupNameTextField: UITextField!
    @IBOutlet weak var profLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberSearchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var users: [PFUser]!
    
    let profTextFieldErrorAlertController = UIAlertController(title: "Professor Name Required", message: "Please enter name of professor", preferredStyle: .alert)
    let studyGroupNameTextFieldErrorAlertController = UIAlertController(title: "Study Group Name Required", message: "Please enter name of study group", preferredStyle: .alert)
    let studyGroupNameDuplicateErrorAlertController = UIAlertController(title: "Study Group with that name already exists!", message: "Please enter another name for your study group", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    var courseName: String!
    let currentUser = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profTextFieldErrorAlertController.addAction(OKAction)
        studyGroupNameTextFieldErrorAlertController.addAction(OKAction)
        studyGroupNameDuplicateErrorAlertController.addAction(OKAction)
        courseLabel.text = courseName
        
        /*
        searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search for people to study with!"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
         */
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: currentUser["username"])
        do {
            try users = query?.findObjects() as! [PFUser]
        } catch {
            //meh
        }
        
        tableView.reloadData()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.user = user
        cell.usernameLabel.text = user.username
        
        //returns false if user has been removed (+) and true if user has been added (-)
        cell.onSelect = { (user: PFUser) -> Bool in
            if (self.users.contains(user)){
                let index = self.users.index(of: user)
                self.users.remove(at: index!)
                return true
            } else {
                self.users.append(user)
                return false
            }
        }
        
        return cell
    }
    
    @IBAction func onAddButton(_ sender: Any) {
        let profName = profTextField.text ?? ""
        let studyGroupName = studyGroupNameTextField.text ?? ""
        
        if(profTextField.text?.isEmpty)!{
            present(profTextFieldErrorAlertController, animated: true)
        } else if (studyGroupNameTextField.text?.isEmpty)!{
            present(studyGroupNameTextFieldErrorAlertController, animated: true)
        } else {
            let query = PFQuery(className: "StudyGroup")
            query.whereKey("name", equalTo: studyGroupName)
            query.findObjectsInBackground{ (findStudyGroup: [PFObject]?, error: Error?) -> Void in
                if findStudyGroup!.count == 0 {
                    self.createStudyGroup(studyGroupName: studyGroupName, profName: profName)
                } else {
                    self.present(self.studyGroupNameDuplicateErrorAlertController, animated: true)
                }
            }
        }
    }
    
    func createStudyGroup(studyGroupName: String, profName: String){
        let newStudyGroup = PFObject(className: "StudyGroup")
        newStudyGroup["name"] = studyGroupName
        newStudyGroup["messages"] = []
        newStudyGroup["course"] = courseLabel.text
        newStudyGroup["professor"] = profName
        
        let relation = newStudyGroup.relation(forKey: "members")
        /*
        for user in users{
            relation.add(user)
        }
         */
        relation.add(currentUser)
        
        newStudyGroup.saveInBackground{(success, error) in
            if success {
                print("study group called \(newStudyGroup["name"]) created")
                /*
                for user in self.users{
                    let relation = user.relation(forKey: "studyGroups")
                    relation.add(newStudyGroup)
                    user.saveInBackground{ (success: Bool, error: Error?) -> Void in
                        if (success){
                            if let navController = self.navigationController {
                                navController.popViewController(animated: true)
                            }
                        } else {
                            print(error?.localizedDescription as Any)
                        }
                    }
                }
                */
                let relation = self.currentUser.relation(forKey: "studyGroups")
                relation.add(newStudyGroup)
                self.currentUser.saveInBackground{ (success: Bool, error: Error?) -> Void in
                    if (success){
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                            navController.popViewController(animated: true)
                            navController.parentPageboy?.scrollToPage(.at(index:0), animated: true)
                        }
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                }
            } else if let error = error {
                print("Problem creating new study group: \(error.localizedDescription)")
            }
        }
    }
}
