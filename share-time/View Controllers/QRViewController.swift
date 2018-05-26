//
//  QRViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/15/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Parse
import QRCode

class QRViewController: UIViewController {

    var studyGroup: PFObject!
    var studyGroupName: String!
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        studyGroupName = studyGroup.object(forKey: "name") as! String
        groupNameLabel.text = studyGroupName
        let qrCode = QRCode(studyGroupName)
        QRImage.image = qrCode!.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
