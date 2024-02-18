//
//  GenresModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/17/24.
//

import Foundation

struct GenresModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ResultModel]
}

struct ResultModel: Codable {
    let id: Int
    let name: String
    let slug: String
    let games_count: Int
    let image_background: String
}
