//
//  PageViewController.swift
//  share-time
//
//  Created by Godwin Pang on 5/13/18.
//  Copyright © 2018 share-time. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDataSource  {

    let pageControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewControllers = [UIViewController]()
        let profileNavController = storyboard.instantiateViewController(withIdentifier: "ProfileNavController") as! UINavigationController
        let mainNavController = storyboard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController
        let findClassNavController = storyboard.instantiateViewController(withIdentifier: "FindClassNavController") as! UINavigationController
        let blobViewController = storyboard.instantiateViewController(withIdentifier: "BlobViewController") 
        viewControllers.append(mainNavController)
        viewControllers.append(blobViewController)
        viewControllers.append(findClassNavController)
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return pageControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return pageControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 1)
    }

}
