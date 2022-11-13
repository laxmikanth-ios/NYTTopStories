//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import UIKit
import DataPersistence

class TopStoriesTabController: UITabBarController {

    // step 1: setting up the datapersistance and its delegate
    private var dataPersistance = DataPersistence<Article>(filename: "savedArticles.plist")
    
    private lazy var newsFeedVC: NewsFeedViewController = {
        let viewController = NewsFeedViewController(dataPersistance)
        viewController.tabBarItem = UITabBarItem(title: "News feed", image: UIImage(systemName: "eyeglasses"), tag: 0)
        return viewController
    }()
    
    private lazy var savedArticlesVC: SavedArticleViewController = {
        let viewController = SavedArticleViewController(dataPersistance)
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

        view.backgroundColor = .yellow
        tabBar.backgroundColor = .systemBackground
        viewControllers = [UINavigationController(rootViewController:newsFeedVC),
                           UINavigationController(rootViewController:savedArticlesVC),
                           UINavigationController(rootViewController: settingsVC)]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
