//
//  GameInfoViewModel.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import Combine
import Foundation

final class GameInfoViewModel: ViewModelProtocol {

    private let gameInfo: GamesResult
    private let imagePublisher = PassthroughSubject<Data, Never>()

    private var subscriptions = Set<AnyCancellable>()

    init(model: GamesResult) {
        gameInfo = model
    }

    func start() {
        try? NetworkService()
            .getData(url: gameInfo.backgroundImage)
            .sink(receiveCompletion: { _ in
                //
            }, receiveValue: { [weak self] data in
                self?.imagePublisher.send(data)
            }).store(in: &subscriptions)
    }

    func getInfo() -> GamesResult {
        gameInfo
    }

    func bind() -> AnyPublisher<Data, Never> {
        imagePublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
