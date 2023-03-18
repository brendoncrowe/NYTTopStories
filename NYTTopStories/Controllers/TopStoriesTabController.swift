//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit

class TopStoriesTabController: UITabBarController {
    
    private lazy var newsFeedVC: NewsFeedViewController = {
        let viewController = NewsFeedViewController()
        viewController.tabBarItem = UITabBarItem(title: "News Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        return viewController
    }()
    
    private lazy var savedArticlesVC: SavedArticlesViewController = {
        let viewController = SavedArticlesViewController()
        viewController.tabBarItem = UITabBarItem(title: "Saved Articles", image: UIImage(systemName: "folder"), tag: 1)
        return viewController
    }()
    
    private lazy var settingsVC: SettingsViewController = {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemGray6
        tabBar.alpha = 0.8
        viewControllers = [newsFeedVC, savedArticlesVC, settingsVC]
    }
}
