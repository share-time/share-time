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
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var studyGroupTableView: UITableView!

    var courseName: String!
    var studyGroups: [PFObject]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyGroupTableView.delegate = self
        studyGroupTableView.dataSource = self
        
        let query = PFQuery(className: "StudyGroup")
        query.whereKey("course", equalTo: courseName)
        query.findObjectsInBackground{ (findStudyGroup: [PFObject]?, error: Error?) -> Void in
            self.studyGroups = findStudyGroup
            self.studyGroupTableView.reloadData()
        }
        classNameLabel.text = courseName
        
        print(studyGroups!)
        
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
        /*
        cell.nameLabel.text = cellStudyGroup["name"] as? String
        cell.profLabel.text = cellStudyGroup["professor"] as? String
        cell.memberCountLabel.text = String((cellStudyGroup["members"] as AnyObject).count) + " Members"
         */
        return cell
    }
    
}
