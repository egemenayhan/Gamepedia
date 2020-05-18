//
//  NetworkingError.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

/// Error type to be used in Networking module
enum NetworkingError: Error {

    /// Indicates that there has been a connection error to the server
    case connectionError(Error)

    /// Indicates that parsing is not possible with the current data and
    /// given type to parse into.
    case decodingFailed(DecodingError)

    /// In case an error occures which is not identified
    case undefined

}
