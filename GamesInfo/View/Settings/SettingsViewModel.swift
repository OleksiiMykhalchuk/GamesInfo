//
//  SettingsViewModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import Combine
import Foundation

final class SettingsViewModel: ViewModelProtocol {

    private let network: NetworkService
    private var genres = CurrentValueSubject<[String], Never>([])
    var storedGenres: [String] = []

    private var subscriptions = Set<AnyCancellable>()
    var coordinator: SettingsCoordinator?

    init(network: NetworkService = .init()) {
        self.network = network
    }

    func start() {
        try? network
            .getData(from: .genres([]))
            .decode(type: GenresModel.self, decoder: JSONDecoder())
            .sink { completion in
                //
            } receiveValue: { model in
                self.genres.send(model.results.map { $0.slug })
            }.store(in: &subscriptions)
        storedGenres = fetchGenres() ?? []
    }

    func getGenres() -> CurrentValueSubject<[String], Never> {
        genres
    }

    func setupTableView() -> [SettingsModel] {
        [SettingsModel(section: "Genre", rows: ["Setup Genres"])]
    }

    func navigateToGenreSetup() {
        coordinator?.navigateGenresView(viewModel: self)
    }

    private func fetchGenres() -> [String]? {
        try? CoreDataService
            .shared
            .fetchGenres()?
            .compactMap({ entity in
                entity.genre
            })
    }
}
