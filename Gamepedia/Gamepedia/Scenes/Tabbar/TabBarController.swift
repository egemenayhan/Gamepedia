//
//  TabBarController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

protocol TabBarInitialRoutable {

    func routeToTabBar()
}

extension TabBarInitialRoutable {

    func routeToTabBar() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {

                return
        }

        let tabbarController = TabBarController()
        appDelegate.tabbarController = tabbarController
        window.rootViewController = tabbarController
        window.makeKeyAndVisible()
    }
}

// MARK: - TabBarController

class TabBarController: UITabBarController {

    private(set) var controllers: [BaseViewController] = []

    init() {

        super.init(nibName: nil, bundle: nil)

        setupViewControllers()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        setupViewControllers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.white248.withAlphaComponent(0.92)
    }

    private func setupViewControllers() {

        controllers = []

        let gameListController = GameListViewController.instantiate()
        gameListController.tabBarItem = UITabBarItem(
            title: "Games",
            image: UIImage(named: "GameTabIcon"),
            selectedImage: nil
        )
        controllers.append(gameListController)

        let favoritesController = FavoritesViewController.instantiate()
        favoritesController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(named: "FavoriteTabIcon"),
            selectedImage: nil
        )
        controllers.append(favoritesController)

        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }
}

