//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-23.
//

import EssentialFeed

class HTTPClientSpy: HTTPClient {
    private struct Task: HTTPClientTask {
        let cancelCompletion: () -> Void
        func cancel() {
            cancelCompletion()
        }
    }
    
    var cancelledURLs: [URL] = []
    var requestURLs: [URL] {
        messages.map { $0.url }
    }
    
    private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        let task = Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
        return task
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
