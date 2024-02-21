//
//  NetworkProtocol.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import Combine
import Foundation

protocol NetworkProtocol {

    init(session: URLSession, logger: AppLogger?)
    func getData(from endPoint: EndPoint) throws -> AnyPublisher<Data, Error>
}
