//
//  FindGroupViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/21/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class FindGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupTableView: UITableView!
    
    static var searchedGroups: [PFObject] = []
    
    let user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        groupTableView.dataSource = self
        groupTableView.delegate = self
        groupTableView.rowHeight = UITableViewAutomaticDimension
        groupTableView.rowHeight = 125
        
        definesPresentationContext = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(FindGroupViewController.updateGroupTableView), name: NSNotification.Name(rawValue: "updateGroupTableView"), object: nil)
        // Do any additional setup after loading the view.
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
    
    func deselectAnySelectedTableViewCell(){
        let selectedIndexPath = groupTableView.indexPathForSelectedRow
        
        if selectedIndexPath != nil {
            groupTableView.deselectRow(at: selectedIndexPath!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return FindGroupViewController.searchedGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyGroupCell") as! StudyGroupCell
        let studyGroup = FindGroupViewController.searchedGroups[indexPath.row]
        cell.studyGroup = studyGroup
        
        return cell
    }
    
    class func searchGroupForSearchText(_ searchText: String){
        let query = PFQuery(className: "StudyGroup")
        query.whereKey("name", matchesText: searchText)
        query.findObjectsInBackground{ (findStudyGroup: [PFObject]?, error: Error?) -> Void in
            if findStudyGroup != nil {
                self.searchedGroups = findStudyGroup!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGroupTableView"), object: nil)
            }
        }
    }
    
    @objc func updateGroupTableView(){
        groupTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studyGroup = FindGroupViewController.searchedGroups[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let groupInfoViewController = storyboard.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
        
        groupInfoViewController.studyGroup = studyGroup
        groupInfoViewController.hideLeaveGroupButton = true
        groupInfoViewController.hideQRButton = true
        
        studyGroup.relation(forKey: "members").query().findObjectsInBackground{
            (members: [PFObject]?, error: Error?) -> Void in
            if error == nil{
                groupInfoViewController.members = members as! [PFUser]
                //check if user has already joined
                self.user?.relation(forKey: "studyGroups").query().findObjectsInBackground{
                    (foundStudyGroups: [PFObject]?, error: Error?) -> Void in
                    for foundStudyGroup in foundStudyGroups!{
                        if (foundStudyGroup["name"] as? String == studyGroup["name"] as? String){
                            groupInfoViewController.hideJoinGroupButton = true
                        }
                    }
                    if let navController = self.navigationController {
                        navController.parentPageboy?.navigationController?.setNavigationBarHidden(true, animated: false)
                        let tabController = navController.parentPageboy as! TabViewController
                        tabController.bar.behaviors = [.autoHide(.always)]
                    }
                    self.navigationController?.pushViewController(groupInfoViewController
                        , animated: true)
                }
            }
        }
    }

}
