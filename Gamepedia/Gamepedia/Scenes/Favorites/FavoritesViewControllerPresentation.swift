//
//  FavoritesViewControllerPresentation.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 17.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

struct FavoritesViewControllerPresentation {

    private(set) var presentations: [GameTableViewCellPresentation] = []

    mutating func update(with state: FavoritesState) {
        presentations = state.favorites.map {
            GameTableViewCellPresentation(
                gameImagePath: $0.imagePath,
                name: $0.name,
                metacriticScore: $0.metacritic,
                genres: $0.genres
            )
        }
    }

}
