//
//  GameDetailViewModel.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 16.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

// MARK: - GameDetailState

struct GameDetailState {

    var gameID: Int
    var game: Game?
    var isFavorite = false

    enum Change {
        case loading
        case loaded
        case gameDetailsFetched
        case showError(NetworkingError)
    }

}

// MARK: - GameDetailViewModel

class GameDetailViewModel {

    typealias StateChangehandler = ((GameDetailState.Change) -> Void)

    private(set) var state: GameDetailState
    private var stateChangeHandler: StateChangehandler?

    init(gameID: Int, game: Game? = nil) {
        state = GameDetailState(gameID: gameID, game: game)
    }

    func addChangeHandler(handler: StateChangehandler?) {
        stateChangeHandler = handler
    }

    func fetchGameDetails() {
        // TODO: implementation
    }

}
