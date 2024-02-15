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
            return "dev"
        case .stage:
            return "stage"
        case .prod:
            return "prod"
        }
    }
}
