//
//  NetworkService.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import Combine
import Foundation

final class NetworkService: NetworkProtocol {

    enum NetworkServiceError: Error {
        case badServerResponse
        case badURL
    }

    private let session: URLSession
    private let environment: Environment = .identify()
    private let logger: AppLogger?

    init(session: URLSession = .shared, logger: AppLogger? = .init()) {
        self.session = session
        self.logger = logger
    }

    func getData(from endPoint: EndPoint) throws -> AnyPublisher<Data, Error> {
        guard let url = try endPoint.makeURL() else {
            throw NetworkServiceError.badURL
        }
        return session
            .dataTaskPublisher(for: url)
            .tryMap { [weak self] element -> Data in
                self?.logger?.debug("\(element.response)")
//                self?.logger?.debug("\(try JSONSerialization.jsonObject(with: element.data))")
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkServiceError.badServerResponse
                }
                return element.data
            }
            .eraseToAnyPublisher()
    }

    func getData(url: String) throws -> AnyPublisher<Data, URLError> {
        guard let url = URL(string: url) else {
            throw NetworkServiceError.badURL
        }
        return session
            .dataTaskPublisher(for: url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
