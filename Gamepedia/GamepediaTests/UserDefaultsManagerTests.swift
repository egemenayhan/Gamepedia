//
//  UserDefaultsManagerTests.swift
//  GamepediaTests
//
//  Created by Egemen Ayhan on 18.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import XCTest
@testable import Gamepedia

class UserDefaultsManagerTests: XCTestCase {

    private enum Constants {
        static let game1 = Game(id: 1, name: "TestGame")
        static let game2 = Game(id: 2, name: "OtherTestGame")
    }

    var mockDefaults: MockUserDefaults!
    var manager: UserDefaultsManager!

    override func setUpWithError() throws {
        mockDefaults = MockUserDefaults()
        manager = UserDefaultsManager(defaults: mockDefaults)
    }

    func testSaveGame() throws {
        manager.save(games: [Constants.game1])
        XCTAssertEqual(mockDefaults.gameList?.count, 1)
    }

    func testGetGames() throws {
        manager.save(games: [Constants.game1, Constants.game2])
        XCTAssertEqual(mockDefaults.gameList?.count, 2)
        XCTAssertEqual(manager.gameList.count, 2)
    }

    func testAddToFavorite() throws {
        manager.toggleFavoriteState(for: Constants.game1)
        XCTAssertEqual(mockDefaults.trackingInfos?.count, 1)
        XCTAssertEqual(manager.gameTrackingInfos.count, 1)
    }

    func testIsFavorite() throws {
        manager.toggleFavoriteState(for: Constants.game1)
        XCTAssertEqual(mockDefaults.trackingInfos?.count, 1)
        XCTAssertEqual(manager.gameTrackingInfos.count, 1)

        XCTAssertEqual(manager.isFavorite(gameID: Constants.game1.id), true)
        manager.toggleFavoriteState(for: Constants.game1)
        XCTAssertEqual(manager.isFavorite(gameID: Constants.game1.id), false)
    }

    func testSetAsRead() throws {
        manager.setAsRead(game: Constants.game1)
        XCTAssertEqual(mockDefaults.trackingInfos?.count, 1)
        XCTAssertEqual(manager.gameTrackingInfos.count, 1)

        let trackinginfo = manager.gameTrackingInfos.first
        XCTAssertEqual(trackinginfo?.isReaded, true)
    }

}

class MockUserDefaults: UserDefaultsType {

    var storage: [String: Any] = [:]

    var gameList: [Game]? {
        return getGameList()
    }

    var trackingInfos: [GameTrackingInfo]? {
        return getGameTrackingInfos()
    }

    private func getGameList() -> [Game]? {
        guard let data = storage[UserDefaultsManager.Constants.gameListKey] as? Data else { return [] }
        return (try? JSONDecoder().decode([Game].self, from: data))
    }

    private func getGameTrackingInfos() -> [GameTrackingInfo]? {
        guard let data = storage[UserDefaultsManager.Constants.gameTrackingInfoKey] as? Data else { return [] }
        return (try? JSONDecoder().decode([GameTrackingInfo].self, from: data))
    }

    func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

}
