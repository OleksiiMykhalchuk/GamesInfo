//
//  GamesInfoTests.swift
//  GamesInfoTests
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import XCTest
@testable import GamesInfo
import Combine

final class GamesInfoTests: XCTestCase {

    private var subscription = Set<AnyCancellable>()

    func testExample() throws {
        let expectation = XCTestExpectation()
        try NetworkService()
            .getData(from: .genres([]))
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Request Failed")
                }
            } receiveValue: { data in
                print(try? JSONSerialization.jsonObject(with: data))
            }.store(in: &subscription)
        wait(for: [expectation], timeout: 6)
    }

    func testGamesRequest() throws {
        let expectation = XCTestExpectation()
        try NetworkService()
            .getData(from: .games([
                URLQueryItem(name: "genres", value: "action,indie"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "page_size", value: "10")
            ]))
            .decode(type: GamesModel.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail()
                }
            } receiveValue: { value in
                print(value)
            }.store(in: &subscription)
        wait(for: [expectation], timeout: 6)
    }

}
