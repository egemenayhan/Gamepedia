//
//  GameDetailsRequest.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 17.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Alamofire

struct GameDetailsRequest: GamepediaEndpoint {

    typealias Response = Game
    var path = "/api/games"
    var method: HTTPMethod = .get

    init(gameID: Int) {
        path = path + "/\(gameID)"
    }

}
