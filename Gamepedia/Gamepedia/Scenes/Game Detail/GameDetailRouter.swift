//
//  GameDetailRouter.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 16.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

protocol GameDetailRoutable {

    func routeToGameDetail(from context: BaseViewController, game: Game)

}

extension GameDetailRoutable {

    func routeToGameDetail(from context: BaseViewController, game: Game) {
        let detailVC = GameDetailViewController.instantiate()
        detailVC.viewModel = GameDetailViewModel(gameID: game.id, game: game)
        detailVC.presentation = GameDetailViewControllerPresentation(game: game, isFavorite: false)
        context.navigationController?.pushViewController(detailVC, animated: true)
    }

}

struct GameDetailRouter {

    func routeToPath(_ path: String) {
        guard let url = URL(string: path) else { return }
        UIApplication.shared.open(url)
    }

}
