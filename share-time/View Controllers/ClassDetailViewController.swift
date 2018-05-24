//
//  ClassDetailViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var createGroupButton: UIBarButtonItem!
    
    //@IBOutlet weak var createeGroupButton: UIButton!
    @IBOutlet weak var studyGroupTableView: UITableView!

    var courseName: String!
    var studyGroups: [PFObject]? = []
    var userStudyGroups: [PFObject]? = []
    let user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyGroupTableView.delegate = self
        studyGroupTableView.dataSource = self
        studyGroupTableView.allowsSelection = false
        studyGroupTableView.rowHeight = 140
        
        let query = PFQuery(className: "StudyGroup")
        query.whereKey("course", equalTo: courseName)
        query.findObjectsInBackground{ (findStudyGroup: [PFObject]?, error: Error?) -> Void in
            self.studyGroups = findStudyGroup
            self.studyGroupTableView.reloadData()
        }
        classNameLabel.text = courseName
        
        user?.relation(forKey: "studyGroups").query().findObjectsInBackground{
            (userStudyGroups: [PFObject]?, error: Error?) -> Void in
            self.userStudyGroups = userStudyGroups
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "StudyGroup")
        query.whereKey("course", equalTo: courseName)
        query.findObjectsInBackground{ (findStudyGroup: [PFObject]?, error: Error?) -> Void in
            self.studyGroups = findStudyGroup
            self.studyGroupTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addGroupSegue"){
            let addStudyGroupViewController = segue.destination as! AddStudyGroupViewController
            addStudyGroupViewController.courseName = self.courseName
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyGroups!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicStudyGroupCell", for: indexPath) as! PublicStudyGroupCell
        let studyGroup = studyGroups![indexPath.row]
        cell.studyGroup = studyGroup
        for findStudyGroup in userStudyGroups!{
            if (findStudyGroup["name"] as? String == studyGroup["name"] as? String){
                cell.joinStudyGroupButton.isHidden = true
            }
        }
        
        return cell
    }
    
}
