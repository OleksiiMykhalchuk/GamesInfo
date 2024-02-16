//
//  Environment.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import Foundation

enum Environment {

    case dev
    case stage
    case prod

    var baseURL: String {
        switch self {
        case .dev:
            return "https://api.rawg.io/api"
        case .stage:
            return "stage"
        case .prod:
            return "prod"
        }
    }

    static func identify() -> Environment {
        #if DEV
        return .dev
        #elseif STAGE
        return .stage
        #elseif PROD
        return .prod
        #else
        return .prod
        #endif
    }
}
