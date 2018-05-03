//
//  FindClassViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class FindClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var classSearchBar: UITextField!
    @IBOutlet weak var classTableView: UITableView!

    var searchController: UISearchController!

    var searchedCourses: [String]!


    override func viewDidLoad() {
        super.viewDidLoad()
        classTableView.dataSource = self
        classTableView.delegate = self
        classTableView.rowHeight = UITableViewAutomaticDimension
        classTableView.estimatedRowHeight = 100
        classTableView.estimatedRowHeight = 85.0
        classTableView.rowHeight = UITableViewAutomaticDimension
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search for classes!"
        classTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false

        //searchedCourses = courses

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedCourses != nil {
            return searchedCourses!.count
        } else {
            return 0
        }
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchedCourses = courses.filter({( data : String) -> Bool in
            return data.lowercased().contains(searchText.lowercased())
        })

        classTableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassCell

        cell.classnameLabel.text = searchedCourses[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = classTableView.indexPath(for: cell){
            let courseName = searchedCourses![indexPath.row]
            let classDetailViewController = segue.destination as! ClassDetailViewController
            classDetailViewController.courseName = courseName
            
            let query = PFQuery(className: "Course")
            query.whereKey("courseName", equalTo: courseName)
            query.findObjectsInBackground{ (findCourse: [PFObject]?, error: Error?) -> Void in
                if findCourse?.count != 0 {
                    classDetailViewController.course = findCourse![0] as? Course
                    //print(classDetailViewController.course)
                    //print(self.course.object(forKey: "studyGroups") as? [PFObject]!)
                    classDetailViewController.studyGroups = classDetailViewController.course.object(forKey: "studyGroups") as? [PFObject]
                } else {
                    let newCourse = PFObject(className: "Course")
                    newCourse["courseName"] = courseName
                    newCourse["studyGroups"] = [] as? [StudyGroup]
                    newCourse.saveInBackground{(success, error) in
                        if success {
                            print("class called \(newCourse["courseName"]) created")
                            classDetailViewController.course = newCourse
                        } else if let error = error {
                            print("Problem creating new study group: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
