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
        tableView.estimatedRowHeight = 50
        emailLabel.text = user?.email
        nameLabel.text = user?.username
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            if let studyGroups = user?["study Groups"] as? [PFObject] {
                return studyGroups.count
            } else {
                return 10
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyGroupCell", for: indexPath) as! StudyGroupCell
        let studyGroup = studyGroups[indexPath.row]
        //cell.groupNameLabel = studyGroup[""]
        return cell
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
