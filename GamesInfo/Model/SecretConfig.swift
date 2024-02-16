//
//  SecretConfig.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/16/24.
//

import Foundation

struct SecretConfig: Codable {
    let rawgApiKey: String

    static func readConfig() throws -> Self {
        guard let secretConfigURL = Bundle.main.url(forResource: "SecretConfig", withExtension: "plist") else {
            throw NSError(domain: "\(Bundle.main.bundleIdentifier ?? "")", code: 0, userInfo: [NSLocalizedDescriptionKey: "SecretConfig.plist does not exist"])
        }
        let data = try Data(contentsOf: secretConfigURL)
        let decoder = PropertyListDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}
