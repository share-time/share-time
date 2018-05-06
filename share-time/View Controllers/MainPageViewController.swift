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
    @IBOutlet weak var studyTritonImage: UIImageView!
    let user = PFUser.current()
    var studyGroups: [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 125
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
                self.tableView.reloadData()
            }
        }
        //self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailLabel.text = user?.email
        nameLabel.text = user?.username
        let imgUrlString = user!["imgUrl"] as? String
        let imgUrl = URL(string: imgUrlString!)!
        personalImage.af_setImage(withURL: imgUrl)

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
            chatViewController.studyGroup = studyGroup as! PFObject
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
