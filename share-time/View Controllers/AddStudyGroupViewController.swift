//
//  AddStudyGroupViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class AddStudyGroupViewController: UIViewController {
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var profTextField: UITextField!
    @IBOutlet weak var studyGroupNameTextField: UITextField!
    @IBOutlet weak var profLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberSearchBar: UITextField!
    
    let profTextFieldErrorAlertController = UIAlertController(title: "Professor Name Required", message: "Please enter name of professor", preferredStyle: .alert)
    let studyGroupNameTextFieldErrorAlertController = UIAlertController(title: "Study Group Name required", message: "Please enter name of study group", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        //does nothing -> dismisses alert view
    }
    
    var course: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profTextFieldErrorAlertController.addAction(OKAction)
        studyGroupNameTextFieldErrorAlertController.addAction(OKAction)
        courseLabel.text = course.object(forKey: "courseName") as? String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddButton(_ sender: Any) {
        let profName = profTextField.text ?? ""
        let studyGroupName = studyGroupNameTextField.text ?? ""
        
        if(profTextField.text?.isEmpty)!{
            present(profTextFieldErrorAlertController, animated: true)
        } else if (studyGroupNameTextField.text?.isEmpty)!{
            present(studyGroupNameTextFieldErrorAlertController, animated: true)
        } else {
            let newStudyGroup = PFObject(className: "StudyGroup")
            newStudyGroup["name"] = studyGroupName
            newStudyGroup["members"] = []
            newStudyGroup["messages"] = []
            newStudyGroup["course"] = courseLabel.text
            newStudyGroup["professor"] = profName
            
            newStudyGroup.saveInBackground{(success, error) in
                if success {
                    print("study group called \(newStudyGroup["name"]) created")
                    if var arrStudyGroups = self.course["studyGroups"] as? [PFObject]{
                        arrStudyGroups.append(newStudyGroup)
                        self.course["studyGroups"] = arrStudyGroups
                    }
                    self.course.saveInBackground{(success, error) in
                        if success{
                            self.performSegue(withIdentifier: "createStudyGroupSegue", sender: nil)
                        } else if let error = error {
                            print("Problem creating new study group: \(error.localizedDescription)")
                        }
                    }
                    //print(self.course["studyGroups"])
                } else if let error = error {
                    print("Problem creating new study group: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let classDetailViewController = segue.destination as! ClassDetailViewController
        classDetailViewController.course = course
        classDetailViewController.courseName = course.object(forKey: "courseName") as? String
    }
    
    
}
