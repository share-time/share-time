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
    @IBAction func onLeaveButton(_ sender: UIButton) {
    }
    @IBOutlet weak var leaveGroupButton: UIButton!
    var studyGroup: PFObject!
    var members: [PFUser] = []
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if members != nil {
            return members.count
        } else {
            return 10
        }
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
