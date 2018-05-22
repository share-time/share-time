//
//  ChangeStudyHoursViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/22/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit

class ChangeStudyHoursViewController: UIViewController {

    @IBOutlet weak var studyHoursSlider: UISlider!
    @IBOutlet weak var studyHours: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studyHoursSlider.setValue(Float(HPTimer.studyHours), animated: false)
        studyHours.text = String(format: "%.1f", HPTimer.studyHours)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        HPTimer.updateStudyHours(hours: studyHoursSlider.value)
    }
    @IBAction func studyHoursChanged(_ sender: Any) {
        studyHours.text = String(format: "%.1f", studyHoursSlider.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
