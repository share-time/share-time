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

    static var searchedCourses: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar;
        classTableView.dataSource = self
        classTableView.delegate = self
        classTableView.rowHeight = UITableViewAutomaticDimension
        classTableView.estimatedRowHeight = 100
        classTableView.estimatedRowHeight = 85.0
        classTableView.rowHeight = UITableViewAutomaticDimension
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search for classes!"
        
        //classTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(FindClassViewController.updateClassTableView), name: NSNotification.Name(rawValue: "updateClassTableView"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if let navController = self.navigationController {
            navController.parentPageboy?.navigationController?.setNavigationBarHidden(false, animated: false)
            let tabController = navController.parentPageboy as! TabViewController
            tabController.bar.behaviors = [.autoHide(.never)]
        }
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

    func updateSearchResults(for searchController: UISearchController) {
        FindClassViewController.filterClassForSearchText(searchController.searchBar.text!)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassCell

        cell.classnameLabel.text = FindClassViewController.searchedCourses[indexPath.row]
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
