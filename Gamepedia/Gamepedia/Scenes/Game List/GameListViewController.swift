//
//  GameListViewController.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

class GameListViewController: BaseViewController {

    let viewModel = GameListViewModel()

    // TODO: implementation
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "GAMES"

        viewModel.stateChangeHandler = handleStateChange(change:)
        viewModel.reloadGames()
    }

    private func handleStateChange(change: GameListState.Change) {
        // TODO: handle changes
        switch change {
        default:
            break
        }
    }
}
