//
//  NetowrkTests.swift
//  GamesInfoTests
//
//  Created by Oleksii Mykhalchuk on 2/21/24.
//

import Combine
@testable import GamesInfo
import XCTest

final class NetworkTests: XCTestCase {

    private var network: NetworkService?

    private var subscription = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        network = NetworkService(session: session)
    }

    override func tearDown() {
        super.tearDown()
        network = nil
        subscription.removeAll()
    }

    func testGoodResponse() throws {
        try handleResponse(isGoodResponse: true)
    }

    func testBadResponse() throws {
        try handleResponse(isGoodResponse: false)
    }
}

extension NetworkTests {

    func handleResponse(isGoodResponse: Bool) throws {
        guard let url = try EndPoint.games([]).makeURL() else {
            XCTFail("Bad URL")
            return
        }
        guard let response = HTTPURLResponse(url: url,
                                             statusCode: isGoodResponse ? 200 : 400,
                                             httpVersion: nil,
                                             headerFields: nil) 
        else {
            XCTFail("Bad Response")
            return
        }
        let mock = """
        {
            "mock": "MOCK"
        }
        """.utf8
        let data = Data(mock)

        MockURLProtocol.handle = { request in
            (data, response)
        }

        let expect = XCTestExpectation()

        try network?
            .getData(from: .games([]))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    isGoodResponse ? expect.fulfill() : XCTFail("Test Failed")
                case .failure(let failure):
                    isGoodResponse ? XCTFail("Test failed with error: \(failure)") : expect.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &subscription)
        wait(for: [expect], timeout: 10)
    }
}
