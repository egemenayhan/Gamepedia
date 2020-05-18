//
//  TabBarController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

// MARK: - TabBarController

class TabBarController: UITabBarController {

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

        var controllers: [BaseViewController] = []

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

