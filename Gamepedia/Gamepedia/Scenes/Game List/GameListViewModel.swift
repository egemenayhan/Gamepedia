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

    var sourceArray: [Game] {
        return isSearchActive ? searchResults : games
    }

    enum Change {

        case loading
        case loaded
        case gamesReloaded
        case nextPageFetched([Game])
        case markedAsRead
        case dataSourceUpdated
        case showError(NetworkingError)
    }

}

// MARK: - GameListViewModel

class GameListViewModel {

    typealias StateChangehandler = ((GameListState.Change) -> Void)

    private enum Constants {
        static let pageSize = 20
    }

    private var stateChangeHandler: StateChangehandler?
    var state = GameListState()
    private var isOperationInProgress = false

    func addChangeHandler(handler: StateChangehandler?) {
        stateChangeHandler = handler
    }

    func reloadGames() {
        guard !isOperationInProgress else { return }
        fetchGames(page: 1)
    }

    func fetchNextPage() {
        // TODO: fetch next search result page if search active
        guard !isOperationInProgress else { return }
        fetchGames(page: state.currentGamesPage + 1, isNextPage: true)
    }

    func fetchGames(page: Int, isNextPage: Bool = false) {
        stateChangeHandler?(.loading)
        isOperationInProgress = true

        let request = GameListRequest(page: page, pageSize: Constants.pageSize)
        NetworkManager.shared.execute(request: request) { [weak self] (responseObject: Response<GameListRequest.Response>) in
            self?.stateChangeHandler?(.loaded)
            self?.isOperationInProgress = false
            switch responseObject.result {
            case .success(let response):
                self?.state.currentGamesPage = page
                if isNextPage {
                    self?.state.games.append(contentsOf: response.games ?? [])
                    self?.stateChangeHandler?(.nextPageFetched(response.games ?? []))
                } else {
                    self?.state.games = response.games ?? []
                    self?.stateChangeHandler?(.gamesReloaded)
                }
            case .failure(let error):
                self?.stateChangeHandler?(.showError(error))
            }
        }
    }

    func search(text: String) {
        // TODO: implementation
    }

}
