//
//  GameListViewControllerPresentation.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 15.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

struct GameListViewControllerPresentation {

    private(set) var presentations: [GameTableViewCellPresentation] = []

    mutating func update(with state: GameListState) {
        presentations = state.sourceArray.map {
            GameTableViewCellPresentation(
                gameImagePath: $0.imagePath,
                name: $0.name,
                metacriticScore: $0.metacritic,
                genres: $0.genres,
                isReaded: false // TODO: fix
            )
        }
    }

    mutating func updateWithNextPage(_ games: [Game]) {
        games.forEach { (game) in
            presentations.append(
                GameTableViewCellPresentation(
                    gameImagePath: game.imagePath,
                    name: game.name,
                    metacriticScore: game.metacritic,
                    genres: game.genres,
                    isReaded: false // TODO: fix
                )
            )
        }
    }
}
