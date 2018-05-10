//
//  GroupInfoViewController.swift
//  share-time
//
//  Created by Guanxin Li on 5/6/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse

class GroupInfoViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leaveGroupButton: UIButton!
    var studyGroup: PFObject!
    var members: [PFUser] = []
    let currentUser = PFUser.current()!
    // CGFloat screenWidth = screenRect.size.width;
    // CGFloat screenHeight = screenRect.size.height;
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @IBAction func onLeaveButton(_ sender: UIButton) {
        let userRelation = currentUser.relation(forKey: "studyGroups")
        userRelation.remove(studyGroup)
        currentUser.saveInBackground{ (success: Bool, error: Error?) -> Void in
            if (success){
                //executes when the study group will be empty when he leaves
                //no sense to have empty study group
                if (self.members.count == 1){
                    self.studyGroup.deleteInBackground(){ (success: Bool, error: Error?) -> Void in
                        if (success){
                            // https://stackoverflow.com/questions/8236940/how-do-i-pop-two-views-at-once-from-a-navigation-controller
                            // pops 2 view controllers from scene
                            var viewControllers = self.navigationController?.viewControllers
                            viewControllers?.removeLast(2)
                            self.navigationController?.setViewControllers(viewControllers!, animated: true)
                        }
                    }
                } else {
                    let studyGroupRelation = self.studyGroup.relation(forKey: "members")
                    studyGroupRelation.remove(self.currentUser)
                    self.studyGroup.saveInBackground(){ (success: Bool, error: Error?) -> Void in
                        if (success){
                            // https://stackoverflow.com/questions/8236940/how-do-i-pop-two-views-at-once-from-a-navigation-controller
                            // pops 2 view controllers from scene
                            var viewControllers = self.navigationController?.viewControllers
                            viewControllers?.removeLast(2)
                            self.navigationController?.setViewControllers(viewControllers!, animated: true)
                        }
                    }
                }
            } else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let member = self.members[indexPath.item]
        cell.memberNameLabel.text = member.username
        cell.memberIconImage.af_setImage(withURL: URL(string: (member["imgUrl"] as! String?)!)!)
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
