//
//  MainViewModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/18/24.
//

import Combine
import Foundation

final class MainViewModel: ViewModelProtocol {

    private let storage = CoreDataService.shared
    private let network: NetworkService
    private var model: GamesModel?
    private var loadingPublisher = PassthroughSubject<Bool, Never>()
    private var nextPagePublisher = PassthroughSubject<Bool, Never>()
    private var currentPage = 1
    private var genres = ""
    private var pageSize = "20"
    private var storeError = PassthroughSubject<Error, Never>()

    private var subscriptions = Set<AnyCancellable>()

    var coordinator: HomeCoordinator?

    let logger = AppLogger()

    init(network: NetworkService = .init()) {
        self.network = network
    }

    func start() {
        do {
            if let genres = try storage.fetchGenres() {
                self.genres = genres.map { $0.genre.lowercased() }.joined(separator: ",")
                logger.debug("\(genres)")
            }
        } catch {
            logger.fault("\(error)")
        }

        fetchGames()
    }

    private func fetchGames() {
        currentPage = 1
        try? network
            .getData(from: .games([
                URLQueryItem(name: "page", value: "\(currentPage)"),
                URLQueryItem(name: "page_size", value: pageSize),
                URLQueryItem(name: "genres", value: "\(genres)")
            ]))
            .decode(type: GamesModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self?.loadingPublisher.send(false)
                    self?.logger.fault("\(error)")
                    self?.storeError.send(error)
                }
            }, receiveValue: { [weak self] model in
                self?.model = model
                self?.loadingPublisher.send(true)
            }).store(in: &subscriptions)
    }

    func bind() -> AnyPublisher<Bool, Never> {
        loadingPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func returnModel() -> GamesModel? {
        model
    }

    func returnError() -> AnyPublisher<Error, Never> {
        storeError
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func nextPage() {
        if model?.next != nil {
            currentPage += 1
            try? network
                .getData(from: .games([
                    URLQueryItem(name: "page", value: "\(currentPage)"),
                    URLQueryItem(name: "page_size", value: pageSize),
                    URLQueryItem(name: "genres", value: "\(genres)")
                ]))
                .decode(type: GamesModel.self, decoder: JSONDecoder())
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        ()
                    case .failure(let error):
                        self?.nextPagePublisher.send(false)
                        self?.storeError.send(error)
                    }
                } receiveValue: { [weak self] model in
                    self?.model?.results?.append(contentsOf: model.results!)
                    self?.model?.next = model.next
                    self?.nextPagePublisher.send(true)
                }.store(in: &subscriptions)
        } else {
            logger.debug("End of the page \(currentPage)")
        }
    }

    func nextPageRefresh() -> AnyPublisher<Bool, Never> {
        nextPagePublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func getImage(url: String) throws -> AnyPublisher<Data, URLError> {
        try network
            .getData(url: url)
            .eraseToAnyPublisher()
    }

    func search(text: String) {
        model = nil
        try? network
            .getData(from: .games([
                URLQueryItem(name: "genres", value: "\(genres)"),
                URLQueryItem(name: "search", value: "\(text)")
            ]))
            .decode(type: GamesModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let failure):
                    self?.loadingPublisher.send(false)
                    self?.storeError.send(failure)
                }
            }, receiveValue: { [weak self] model in
                self?.model = model
                self?.loadingPublisher.send(true)
            }).store(in: &subscriptions)
    }

    func cancelSearch() {
        model = nil
        fetchGames()
    }

    func navigate(index: Int) {
        guard let item = model?.results?[index] else { return }
        coordinator?.navigateToGameInfo(model: item)
    }
}
