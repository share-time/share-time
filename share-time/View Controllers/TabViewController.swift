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

class TabViewController: TabmanViewController, PageboyViewControllerDataSource, UISearchResultsUpdating {

    var qrBarButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    
    let tabControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewControllers = [UIViewController]()
        let findClassNavController = storyboard.instantiateViewController(withIdentifier: "FindClassNavController") as! UINavigationController
        let findGroupNavController = storyboard.instantiateViewController(withIdentifier: "FindGroupNavController") as! UINavigationController
        //let profileNavController = storyboard.instantiateViewController(withIdentifier: "ProfileNavController") as! UINavigationController
        viewControllers.append(findClassNavController)
        viewControllers.append(findGroupNavController)
        //viewControllers.append(profileNavController)
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
                
        self.bar.items = [Item(title: "Course"),Item(title: "Group")]
        
        bar.style = .buttonBar
        
        bar.appearance = PresetAppearanceConfigs.forStyle(self.bar.style, currentAppearance: self.bar.appearance)
        
        addBarButton()
        
        
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = self.searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search for study groups!"
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        FindClassViewController.filterClassForSearchText(searchController.searchBar.text!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateClassTableView"), object: nil)
        
        FindGroupViewController.searchGroupForSearchText(searchController.searchBar.text!)
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
        return .first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
