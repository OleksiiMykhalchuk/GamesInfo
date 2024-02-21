//
//  GamesModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/18/24.
//

import Foundation

struct GamesModel: Codable {
    let count: Int
    var next: String?
    let previous: String?
    var results: [GamesResult]?
}

struct GamesResult: Codable, Hashable {
    let uuid = UUID()
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

    static func == (lhs: GamesResult, rhs: GamesResult) -> Bool {
        lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Genre: Codable {
    let name: String
}
