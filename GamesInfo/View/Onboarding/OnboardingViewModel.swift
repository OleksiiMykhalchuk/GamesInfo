//
//  OnboardingViewModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/16/24.
//

import Combine
import Foundation

final class OnboardingViewModel: ViewModelProtocol {

    private let network: NetworkProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var selectedGenres: [String] = []
    private var genres: GenresModel?
    private let loadingPublisher = PassthroughSubject<Bool, Error>()
    private var coordinator: OnboardingCoordinator?
    private let storage = CoreDataService.shared

    let logger: AppLogger

    init(network: NetworkProtocol, logger: AppLogger = AppLogger(), coordinator: OnboardingCoordinator) {
        self.network = network
        self.logger = logger
        self.coordinator = coordinator
    }

    func start() {
        do {
            try network
                .getData(from: .genres([]))
                .receive(on: RunLoop.main)
                .decode(type: GenresModel.self, decoder: JSONDecoder())
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.loadingPublisher.send(completion: .finished)
                    case .failure(let error):
                        self?.loadingPublisher.send(completion: .failure(error))
                        self?.logger.fault("\(error)")
                    }
                } receiveValue: { [weak self] value in
                    self?.genres = value
                }.store(in: &subscriptions)

        } catch {
            logger.fault("\(error)")
        }
    }

    func bind() -> AnyPublisher<Bool, Error> {
        loadingPublisher
            .eraseToAnyPublisher()
    }

    func genresName() -> [String] {
        genres?.results.map { $0.name } ?? []
    }

    func addGenre(_ value: String) -> Int {
        selectedGenres.append(value)
        logger.debug("\(selectedGenres)")
        return selectedGenres.count
    }

    func removeGenre(_ value: String) -> Int {
        selectedGenres.removeAll { name in
            name == value
        }
        logger.debug("\(selectedGenres)")
        return selectedGenres.count
    }

    func navigateToMain() {
        coordinator?.showMain()
    }

    func saveSelectedGenres() {
        storage.addGenres(selectedGenres)
    }
}
