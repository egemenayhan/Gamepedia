//
//  GlobalVariables.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import Foundation

enum Environment {
    case beta
    case prod
}

struct Global {

    // TODO: update according to build configuration
    private(set) static var environment: Environment = .prod

    static let minimumCharacterCountForSearch = 3

    enum NotificationInfoKeys {
        case gameID
    }

}

extension Notification.Name {

    static let markedAsReadNotification = Notification.Name("GameMarkedAsRead")
    static let favoriteStateUpdatedNotification = Notification.Name("GameFavoriteStateUpdated")

}
