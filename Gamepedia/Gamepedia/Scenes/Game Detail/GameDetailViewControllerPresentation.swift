//
//  GameDetailViewControllerPresentation.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 16.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

struct GameDetailViewControllerPresentation {

    var gameImagePath: String?
    var name: String?
    var description: NSAttributedString?
    var redditPath: String?
    var websitePath: String?
    var isFavorite: Bool = false

    init(game: Game, isFavorite: Bool) {
        updateFields(game: game)
        self.isFavorite = isFavorite
    }

    mutating func update(with state: GameDetailState) {
        guard let game = state.game else { return }
        updateFields(game: game)
        isFavorite = state.isFavorite
    }

    mutating private func updateFields(game: Game) {
        gameImagePath = game.imagePath
        name = game.name
        description = game.description
        redditPath = game.redditPath
        websitePath = game.websitePath
    }

}
