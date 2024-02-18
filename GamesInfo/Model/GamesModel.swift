//
//  GamesModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/18/24.
//

import Foundation

struct GamesModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GamesResult]
}

struct GamesResult: Codable {
    let id: Int
    let name: String
    let backgroundImage: String
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case genres
    }
}

struct Genre: Codable {
    let name: String
}
