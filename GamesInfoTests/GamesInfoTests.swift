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

}
