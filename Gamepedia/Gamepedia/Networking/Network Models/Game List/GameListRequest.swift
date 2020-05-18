//
//  GameListRequest.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Alamofire

struct GameListRequest: GamepediaEndpoint {

    enum Constants {
        static let defaultPage = 1
        static let defaultPageSize = 10
        enum Parameters {
            static let pageKey = "page"
            static let pageSizeKey = "page_size"
            static let searchKey = "search"
        }
    }

    typealias Response = GameListResponse
    var path = "/api/games"
    var method: HTTPMethod = .get
    var parameters: [String : Any]

    init(
        page: Int = Constants.defaultPage,
        pageSize: Int = Constants.defaultPageSize,
        searchText: String? = nil
    ) {
        parameters = [
            Constants.Parameters.pageKey: page,
            Constants.Parameters.pageSizeKey: pageSize
        ]
        if let searchText = searchText {
            parameters[Constants.Parameters.searchKey] = searchText
        }
    }
}
