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

    private var searchResults: [Game] = []
    private var games: [Game] = []
    private var currentGamesPage = 1
    private var currentSearchPage = 1
    private var isNextPageAvailableForGames = false
    private var isNextPageAvailableForSearch = false
    var searchText: String? {
        didSet {
            if searchText == nil {
                searchResults = []
            }
        }
    }

    var isSearchActive: Bool {
        return !(searchText?.isEmpty ?? true)
    }
    var sourceArray: [Game] {
        return isSearchActive ? searchResults : games
    }
    var currentSourcePage: Int {
        return isSearchActive ? currentSearchPage : currentGamesPage
    }
    var isNextPageAvailable: Bool {
        return isSearchActive ? isNextPageAvailableForSearch : isNextPageAvailableForGames
    }

    mutating func setCurrentPage(_ page: Int, isNextPageAvailable: Bool) {
        if isSearchActive {
            currentSearchPage = page
            isNextPageAvailableForSearch = isNextPageAvailable
        } else {
            currentGamesPage = page
            isNextPageAvailableForGames = isNextPageAvailable
        }
    }

    mutating func updateSourceArray(_ games: [Game], isNextPage: Bool = false) {
        if isSearchActive {
            if isNextPage {
                searchResults.append(contentsOf: games)
            } else {
                searchResults = games
            }
        } else {
            if isNextPage {
                self.games.append(contentsOf: games)
            } else {
                self.games = games
            }
        }
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
    private(set) var state = GameListState()
    private var activeNetworkTask: URLSessionTask?
    private var isOperationInProgress: Bool {
        return activeNetworkTask != nil
    }

    func addChangeHandler(handler: StateChangehandler?) {
        stateChangeHandler = handler
    }

    func reloadGames() {
        guard !isOperationInProgress else { return }
        fetchGames(page: 1, searchText: state.searchText)
    }

    func fetchNextPage() {
        guard !isOperationInProgress, state.isNextPageAvailable else { return }
        fetchGames(
            page: state.currentSourcePage + 1,
            isNextPage: true,
            searchText: state.searchText
        )
    }

    func fetchGames(page: Int, isNextPage: Bool = false, searchText: String? = nil) {
        stateChangeHandler?(.loading)

        let request = GameListRequest(page: page, pageSize: Constants.pageSize, searchText: searchText)
        activeNetworkTask = NetworkManager.shared.execute(request: request) { [weak self] (responseObject: Response<GameListRequest.Response>) in
            self?.stateChangeHandler?(.loaded)
            self?.activeNetworkTask = nil
            switch responseObject.result {
            case .success(let response):
                self?.state.setCurrentPage(page, isNextPageAvailable: response.isNextPageAvailable)
                self?.state.updateSourceArray(response.games ?? [], isNextPage: isNextPage)
                if isNextPage {
                    self?.stateChangeHandler?(.nextPageFetched(response.games ?? []))
                } else {
                    self?.stateChangeHandler?(.gamesReloaded)
                }
            case .failure(let error):
                self?.stateChangeHandler?(.showError(error))
            }
        }
    }

    // MARK: - Search

    func search(text: String) {
        state.searchText = text
        stateChangeHandler?(.dataSourceUpdated)

        if let task = activeNetworkTask {
            task.cancel()
        }
        fetchGames(page: 1, searchText: text)
    }

    func deactivateSearch() {
        state.searchText = nil
        stateChangeHandler?(.dataSourceUpdated)
    }

}
