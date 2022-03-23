//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-23.
//

import EssentialFeed

class HTTPClientSpy: HTTPClient {
    var requestURLs: [URL] {
        messages.map { $0.url }
    }
    
    private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
    
    func getFrom(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: messages[index].url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
