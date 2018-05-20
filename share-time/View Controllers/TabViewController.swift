//
//  TabViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/20/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class TabViewController: TabmanViewController, PageboyViewControllerDataSource {

    var qrBarButton: UIBarButtonItem!
    
    let tabControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewControllers = [UIViewController]()
        let findClassNavController = storyboard.instantiateViewController(withIdentifier: "FindClassNavController") as! UINavigationController
        let profileNavController = storyboard.instantiateViewController(withIdentifier: "ProfileNavController") as! UINavigationController
        viewControllers.append(findClassNavController)
        viewControllers.append(profileNavController)
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        self.bar.items = [Item(title: "Course"),Item(title: "Profile")]
        
        bar.style = .buttonBar
        
        bar.appearance = PresetAppearanceConfigs.forStyle(self.bar.style, currentAppearance: self.bar.appearance)
        
        addBarButton()
    }
    
    func addBarButton(){
        let qrBarButton = UIBarButtonItem(title: "QR", style: .plain, target: self, action: #selector(qrBarButtonPressed(sender:)))
        navigationItem.setRightBarButton(qrBarButton, animated: false)
        self.qrBarButton = qrBarButton
    }
    
    @objc func qrBarButtonPressed(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "toScanSegue", sender: nil)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return tabControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return tabControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
