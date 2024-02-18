//
//  MainViewModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/18/24.
//

import Foundation

final class MainViewModel: ViewModelProtocol {

    private let storage = CoreDataService.shared
    let logger = AppLogger()

    func start() {
        do {
            let genres = try storage.fetchGenres()
            logger.debug("\(genres)")
        } catch {
            logger.fault("\(error)")
        }
    }
}
