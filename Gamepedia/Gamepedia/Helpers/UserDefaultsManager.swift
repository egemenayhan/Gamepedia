//
//  UserDefaultsManager.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 17.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    private enum Constants {
        static let gameListKey = "GameList"
        static let gameTrackingInfoKey = "GameTrackingInfo"
    }

    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private(set) var gameTrackingInfos: [GameTrackingInfo] = []
    private(set) var gameList: [Game] = []

    init() {
        gameTrackingInfos = getGameTrackingInfos()
        gameList = getGameList()
    }

    private func getGameList() -> [Game] {
        guard let data = defaults.data(forKey: Constants.gameListKey) else { return [] }
        return (try? JSONDecoder().decode([Game].self, from: data)) ?? []
    }

    private func getGameTrackingInfos() -> [GameTrackingInfo] {
        guard let data = defaults.data(forKey: Constants.gameTrackingInfoKey) else { return [] }
        return (try? JSONDecoder().decode([GameTrackingInfo].self, from: data)) ?? []
    }

    func save(games: [Game]) {
        gameList = games
        let data = try? JSONEncoder().encode(games)
        defaults.set(data, forKey: Constants.gameListKey)
    }

    private func saveGameTrackingInfos() {
        let data = try? JSONEncoder().encode(gameTrackingInfos)
        defaults.set(data, forKey: Constants.gameTrackingInfoKey)
    }

    // MARK: - Favoorite operations

    func toggleFavoriteState(for gameID: Int) {
        if let index = gameTrackingInfos.firstIndex(where: { $0.gameID == gameID }) {
            var info = gameTrackingInfos[index]
            info.isFavorite.toggle()
            gameTrackingInfos[index] = info
        } else {
            let info = GameTrackingInfo(gameID: gameID, isReaded: false, isFavorite: true)
            gameTrackingInfos.append(info)
            saveGameTrackingInfos()
        }
    }

    func isFavorite(gameID: Int) -> Bool {
        return gameTrackingInfos.first(where: { $0.gameID == gameID })?.isFavorite ?? false
    }

    // MARK: - Read operations

    func setAsRead(gameID: Int) {
        if let index = gameTrackingInfos.firstIndex(where: { $0.gameID == gameID }) {
            var info = gameTrackingInfos[index]
            info.isReaded.toggle()
            gameTrackingInfos[index] = info
        } else {
            let info = GameTrackingInfo(gameID: gameID, isReaded: true, isFavorite: false)
            gameTrackingInfos.append(info)
            saveGameTrackingInfos()
        }
    }

}
