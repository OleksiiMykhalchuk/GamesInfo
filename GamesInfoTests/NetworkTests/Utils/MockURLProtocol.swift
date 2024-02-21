//
//  MockURLProtocol.swift
//  GamesInfoTests
//
//  Created by Oleksii Mykhalchuk on 2/21/24.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    static var handle: ((URLRequest) -> (Data, HTTPURLResponse))?

    class override func canInit(with request: URLRequest) -> Bool {
        true
    }

    class override func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    class override func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let (data, response) = Self.handle?(request) else { return }

        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
