//
//  HomeScreebViewController.swift
//  FirebaseSample
//
//  Created by Admin on 14/02/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create instances of your view controllers
        let firstViewController = HomeTabViewController()
        let secondViewController = PostDataTabViewController()

        // Set titles and images for tab bar items
        firstViewController.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "homekit"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "POST", image: UIImage(systemName: "plus.circle.fill"), tag: 1)

        // Set view controllers for the tab bar controller
        viewControllers = [firstViewController, secondViewController]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

