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
    private var genresEntity: [GenreEntity]? = []
    private lazy var logger = AppLogger()
    private lazy var storage = CoreDataService.shared
    var storedGenres: [String] = []

    var storedGenresCount: Int {
        storedGenres.count
    }

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
    }

    func getGenres() -> CurrentValueSubject<[String], Never> {
        fetchGenres()
        return genres
    }

    func setupTableView() -> [SettingsModel] {
        [SettingsModel(section: "Genre", rows: ["Setup Genres"])]
    }

    func navigateToGenreSetup() {
        coordinator?.navigateGenresView(viewModel: self)
    }

    func fetchGenres() {
        genresEntity = try? CoreDataService
            .shared
            .fetchGenres()
        storedGenres = genresEntity?.compactMap { $0.genre } ?? []
    }

    func addGenre(_ genre: String) {
        storedGenres.append(genre)
    }

    func removeGenre(_ genre: String) {
        storedGenres.removeAll { value in
            value == genre
        }
    }

    func saveChanges() {
        let saveGenres = storedGenres.filter { value in
            !(genresEntity ?? [])
                .compactMap { entity in
                    entity.genre
                }.contains(value)
        }
        let removeGenre = (genresEntity ?? []).filter { entity in
            !storedGenres.contains(entity.genre)
        }
        logger.debug("Genres to Add \(saveGenres)")
        logger.debug("Genres to delete \(removeGenre.compactMap({ $0.genre }))")
        storage.addGenres(saveGenres)
        storage.removeGenres(removeGenre)
    }
}
