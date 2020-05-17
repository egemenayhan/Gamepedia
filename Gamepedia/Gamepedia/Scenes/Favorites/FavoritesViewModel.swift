//
//  FavoritesViewModel.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 17.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

// MARK: - FavoritesState

struct FavoritesState {

    var favorites: [Game] = []

    init() {
        updateFavorites()
    }

    mutating func updateFavorites() {
        favorites = UserDefaultsManager.shared.gameTrackingInfos.filter({ $0.isFavorite }).compactMap({ $0.game })
    }

    enum Change {
        case favoritesUpdated
    }

}

// MARK: - FavoritesViewModel

class FavoritesViewModel {

    typealias StateChangehandler = ((FavoritesState.Change) -> Void)

    private var stateChangeHandler: StateChangehandler?
    var state = FavoritesState()

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteStateUpdatedForGame(_:)),
            name: .favoriteStateUpdatedNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func addChangeHandler(handler: StateChangehandler?) {
        stateChangeHandler = handler
    }

    @objc func favoriteStateUpdatedForGame(_ notification: Notification) {
        state.updateFavorites()
        stateChangeHandler?(.favoritesUpdated)
    }

    func unfavoriteGame(at index: Int) {
        UserDefaultsManager.shared.toggleFavoriteState(for: state.favorites[index])
    }

}
