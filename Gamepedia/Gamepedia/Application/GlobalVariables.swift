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
}
