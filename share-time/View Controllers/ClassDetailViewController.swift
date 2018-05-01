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
    var course: PFObject!
    var studyGroups: [PFObject]? = []
    
    override func viewDidLoad() {
        
        let query = PFQuery(className: "Course")
        query.whereKey("courseName", equalTo: courseName)
        query.findObjectsInBackground{ (findCourse: [PFObject]?, error: Error?) -> Void in
            if findCourse?.count != 0 {
                self.course = findCourse![0] as? Course
                self.studyGroups = findCourse![0]["studyGroups"] as? [PFObject]
            } else {
                let newCourse = PFObject(className: "Course")
                newCourse["courseName"] = self.courseName
                newCourse["studyGroups"] = [] as? [StudyGroup]
                newCourse.saveInBackground{(success, error) in
                    if success {
                        print("class called \(newCourse["courseName"]) created")
                        self.course = newCourse
                    } else if let error = error {
                        print("Problem creating new study group: \(error.localizedDescription)")
                    }
                }
            }
        }
        classNameLabel.text = courseName
        
        print(course)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addGroupSegue"){
            let addStudyGroupViewController = segue.destination as! AddStudyGroupViewController
            addStudyGroupViewController.course = self.course
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (course["studyGroups"] as? [StudyGroup])!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicStudyGroupCell", for: indexPath) as! PublicStudyGroupCell
        let cellStudyGroup = studyGroups![indexPath.row]
        cell.nameLabel.text = cellStudyGroup["name"] as? String
        cell.profLabel.text = cellStudyGroup["professor"] as? String
        cell.memberCountLabel.text = String((cellStudyGroup["members"] as AnyObject).count)
        return cell
    }
    
}
