//
//  GameListViewModel.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 15.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

// MARK: - GameListState

struct GameListState {

    var searchResults: [Game] = []
    var games: [Game] = []
    var currentGamesPage = 1
    var currentSearchPage = 1
    var isSearchActive = false

    enum Change {

        case loading
        case gamesFetched
        case markedAsRead
        case dataSourceUpdated
        case showError(NetworkingError)
    }

}

// MARK: - GameListViewModel

class GameListViewModel {

    var stateChangeHandler: ((GameListState.Change) -> Void)?
    var state = GameListState()

    func reloadGames() {
        fetchGames(page: 1)
    }

    func fetchNextPage() {
        // TODO: fetch next search result page if search active
        fetchGames(page: state.currentGamesPage + 1, isNextPage: true)
    }

    func fetchGames(page: Int, isNextPage: Bool = false) {
        stateChangeHandler?(.loading)
        let request = GameListRequest(page: page)
        NetworkManager.shared.execute(request: request) { [weak self] (responseObject: Response<GameListRequest.Response>) in
            switch responseObject.result {
            case .success(let response):
                if isNextPage {
                    self?.state.games.append(contentsOf: response.games ?? [])
                } else {
                    self?.state.games = response.games ?? []
                }
                self?.stateChangeHandler?(.gamesFetched)
            case .failure(let error):
                self?.stateChangeHandler?(.showError(error))
            }
        }
    }

    func search(text: String) {
        // TODO: implementation
    }

}
