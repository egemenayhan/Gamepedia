//
//  GameListResponse.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

struct GameListResponse: Decodable {

    let nextPage: String?
    let games: [Game]?

    enum CodingKeys: String, CodingKey {
        case nextPage = "next"
        case games = "results"
    }
}
