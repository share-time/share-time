//
//  FindClassViewController.swift
//  share-time
//
//  Created by Godwin Pang on 4/14/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class FindClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var classTableView: UITableView!

    static var searchedCourses: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        classTableView.dataSource = self
        classTableView.delegate = self
        classTableView.rowHeight = UITableViewAutomaticDimension
        classTableView.estimatedRowHeight = 100
        classTableView.estimatedRowHeight = 85.0
        classTableView.rowHeight = UITableViewAutomaticDimension
        
        definesPresentationContext = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(FindClassViewController.updateClassTableView), name: NSNotification.Name(rawValue: "updateClassTableView"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if let navController = self.navigationController {
            navController.parentPageboy?.navigationController?.setNavigationBarHidden(false, animated: false)
            let tabController = navController.parentPageboy as! TabViewController
            tabController.bar.behaviors = [.autoHide(.never)]
        }
        deselectAnySelectedTableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FindClassViewController.searchedCourses != nil {
            return FindClassViewController.searchedCourses!.count
        } else {
            return 0
        }
    }

    class func filterClassForSearchText(_ searchText: String, scope: String = "All") {
        searchedCourses = Helper.courses.filter({( data : String) -> Bool in
            return data.lowercased().contains(searchText.lowercased())
        })
    }
    
    @objc func updateClassTableView(){
        classTableView.reloadData()
    }
    
    func deselectAnySelectedTableViewCell(){
        let selectedIndexPath = classTableView.indexPathForSelectedRow
        
        if selectedIndexPath != nil {
            classTableView.deselectRow(at: selectedIndexPath!, animated: true)
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassCell

        cell.classnameLabel.text = FindClassViewController.searchedCourses[indexPath.row]
        cell.contentView.backgroundColor = Color.lightGreen
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = classTableView.indexPath(for: cell){
            let courseName = FindClassViewController.searchedCourses![indexPath.row]
            let classDetailViewController = segue.destination as! ClassDetailViewController
            classDetailViewController.courseName = courseName
        }
        if let navController = self.navigationController {
            navController.parentPageboy?.navigationController?.setNavigationBarHidden(true, animated: false)
            let tabController = navController.parentPageboy as! TabViewController
            tabController.bar.behaviors = [.autoHide(.always)]
        }
    }
}
