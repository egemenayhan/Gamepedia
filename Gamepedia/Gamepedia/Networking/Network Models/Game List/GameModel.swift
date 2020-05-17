//
//  GameModel.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

// MARK: - Game

struct Game: Codable {

    let id: Int
    let name: String?
    let metacritic: Int?
    let imagePath: String?
    private let htmlDescription: String?
    var description: NSAttributedString? = nil
    let redditPath: String?
    let websitePath: String?
    let genres: [String]?

    var isFavorite: Bool {
        return UserDefaultsManager.shared.isFavorite(gameID: id)
    }
    var isReaded: Bool {
        return UserDefaultsManager.shared.isReaded(gameID: id)
    }

    enum CodingKeys: String, CodingKey {
        case name, metacritic, description, genres, id
        case websitePath = "website"
        case imagePath = "background_image"
        case redditPath = "reddit_url"
    }

    // Decoding

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        metacritic = try? container.decode(Int.self, forKey: .metacritic)
        htmlDescription = try? container.decode(String.self, forKey: .description)
        if let htmlText = htmlDescription {
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

    // Encoding

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try? container.encode(name, forKey: .name)
        try? container.encode(metacritic, forKey: .metacritic)
        try? container.encode(imagePath, forKey: .imagePath)
        try? container.encode(redditPath, forKey: .redditPath)
        try? container.encode(websitePath, forKey: .websitePath)
        try? container.encode(genres, forKey: .genres)
        try? container.encode(htmlDescription, forKey: .description)
    }

}

// MARK: - Genre

struct Genre: Codable {

    let name: String?

}

// MARK: - GameTrackingInfo

struct GameTrackingInfo: Codable {

    var gameID: Int
    var isReaded: Bool
    var isFavorite: Bool

}
