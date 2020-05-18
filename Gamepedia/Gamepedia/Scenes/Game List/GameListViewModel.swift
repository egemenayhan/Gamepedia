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
    var isSearchActive: Bool = false

    var sourceArray: [Game] {
        let gameSource = games.count > 0 ? games : savedGames
        return isSearchActive ? searchResults : gameSource
    }
    var currentSourcePage: Int {
        return isSearchActive ? currentSearchPage : currentGamesPage
    }
    var isNextPageAvailable: Bool {
        return isSearchActive ? isNextPageAvailableForSearch : isNextPageAvailableForGames
    }
    var savedGames: [Game] {
        return UserDefaultsManager.shared.gameList
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
            UserDefaultsManager.shared.save(games: self.games)
        }
    }

    enum Change {

        case loading
        case loaded
        case gamesReloaded
        case nextPageFetched([Game])
        case dataSourceUpdated
        case gameSetAsReaded(atIndex: Int)
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

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(gameSetAsReaded(_:)),
            name: .markedAsReadNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func addChangeHandler(handler: StateChangehandler?) {
        stateChangeHandler = handler
    }

    @objc private func gameSetAsReaded(_ notification: Notification) {
        guard let gameID = notification.userInfo?[Global.NotificationInfoKeys.gameID] as? Int,
            let gameIndex = state.sourceArray.firstIndex(where: { $0.id == gameID }) else { return }

        stateChangeHandler?(.gameSetAsReaded(atIndex: gameIndex))
    }

    // MARK: - Network operations

    func reloadGames() {
        guard !isOperationInProgress, (!state.isSearchActive || (state.searchText?.count ?? 0 >= Global.minimumCharacterCountForSearch)) else {
            stateChangeHandler?(.loaded)
            return
        }
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
        state.searchText = text.lowercased()
        stateChangeHandler?(.dataSourceUpdated)

        if let task = activeNetworkTask {
            task.cancel()
        }
        fetchGames(page: 1, searchText: text)
    }

    func enableSearch(_ isEnabled: Bool) {
        state.isSearchActive = isEnabled
        state.searchText = isEnabled ? "" : nil
        stateChangeHandler?(.dataSourceUpdated)
    }

}
