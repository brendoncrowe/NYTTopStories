//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit
import DataPersistence

class TopStoriesTabController: UITabBarController {
    
    private var dataPersistence = DataPersistence<Article>(filename: "savedArticles.plist")
    
    private lazy var newsFeedVC: NewsFeedViewController = {
        let viewController = NewsFeedViewController()
        viewController.tabBarItem = UITabBarItem(title: "News Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        viewController.dataPersistence = dataPersistence
        return viewController
    }()
    
    private lazy var savedArticlesVC: SavedArticlesViewController = {
        let viewController = SavedArticlesViewController()
        viewController.tabBarItem = UITabBarItem(title: "Saved Articles", image: UIImage(systemName: "folder"), tag: 1)
        viewController.dataPersistence = dataPersistence
        
        // ***Set the DataPersistence delegate HERE***
        viewController.dataPersistence.delegate = viewController
        return viewController
    }()
    
    private lazy var settingsVC: SettingsViewController = {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemBackground
        tabBar.alpha = 0.9
        viewControllers = [UINavigationController(rootViewController: newsFeedVC), UINavigationController(rootViewController: savedArticlesVC), UINavigationController(rootViewController: settingsVC)]
    }
}
