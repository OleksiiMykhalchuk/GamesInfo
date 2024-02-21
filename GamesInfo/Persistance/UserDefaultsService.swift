//
//  UserDefaultsService.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import Foundation

final class UserDefaultsService {

    enum Constants {
        static let onboarding = "onboarding"
    }

    static let shared = UserDefaultsService()

    private let userDefaults = UserDefaults.standard

    private init() {}

    func setOnboarded() {
        userDefaults.set(true, forKey: Constants.onboarding)
    }

    func isOnboarded() -> Bool {
        userDefaults.bool(forKey: Constants.onboarding)
    }
}
