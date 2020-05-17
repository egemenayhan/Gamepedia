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
        stateChangeHandler?(.loading)
        let request = GameDetailsRequest(gameID: state.gameID)
        NetworkManager.shared.execute(request: request) { [weak self] (responseObject: Response<GameDetailsRequest.Response>) in
            self?.stateChangeHandler?(.loaded)
            switch responseObject.result {
            case .success(let game):
                self?.state.game = game
                self?.stateChangeHandler?(.gameDetailsFetched)
            case .failure(let error):
                self?.stateChangeHandler?(.showError(error))
            }
        }
    }

}
