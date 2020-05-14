//
//  GamepediaEndpoint.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

protocol GamepediaEndpoint: Endpoint {}

extension GamepediaEndpoint {

    func apiForEnvironment(_ environment: Environment) -> API {
        switch environment {
        case .beta:
            return API(baseURL: BaseURL(scheme: "https", host: "api.rawg.io"))
        case .prod:
            return API(baseURL: BaseURL(scheme: "https", host: "api.rawg.io"))
        }
    }
}
