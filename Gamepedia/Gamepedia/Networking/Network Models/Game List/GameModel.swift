//
//  GameModel.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

struct Game: Decodable {

    let id: Int
    let name: String?
    let metacritic: Int?
    let imagePath: String?
    var description: NSAttributedString? = nil
    let redditPath: String?
    let websitePath: String?
    let genres: [String]?

    enum CodingKeys: String, CodingKey {
        case name, metacritic, description, genres, id
        case websitePath = "website"
        case imagePath = "background_image"
        case redditPath = "reddit_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        metacritic = try? container.decode(Int.self, forKey: .metacritic)
        if let htmlText = try? container.decode(String.self, forKey: .description) {
            let data = Data(htmlText.utf8)
            if let attributedString = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            ) {
                description = attributedString
            }
        }
        imagePath = try? container.decode(String.self, forKey: .imagePath)
        websitePath = try? container.decode(String.self, forKey: .websitePath)
        redditPath = try? container.decode(String.self, forKey: .redditPath)
        genres = try? container.decode([Genre].self, forKey: .genres).compactMap({ $0.name })
    }

}

struct Genre: Decodable {

    let name: String?

}
