//
//  EndPoint.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/16/24.
//

import Foundation

enum EndPoint {
    case genres([URLQueryItem])
    case games([URLQueryItem])

    func makeURL() throws -> URL? {
        let environment = Environment.identify()
        var baseURL = URL(string: environment.baseURL)
        let apiKey = try SecretConfig.readConfig().rawgApiKey
        baseURL?.append(queryItems: [URLQueryItem(name: "key", value: apiKey)])
        switch self {
        case .genres(let queryItems):
            baseURL?.append(path: "genres")
            baseURL?.append(queryItems: queryItems)
            return baseURL
        case .games(let queryItems):
            baseURL?.append(path: "games")
            baseURL?.append(queryItems: queryItems)
            return baseURL
        }
    }
}
