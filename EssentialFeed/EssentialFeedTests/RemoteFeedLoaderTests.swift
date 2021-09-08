//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-01.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://custom-url.com")!
        let (sut, client) = makeSUT(with: url)
        sut.load { _ in }
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://custom-url.com")!
        let (sut, client) = makeSUT(with: url)
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors: [RemoteFeedLoader.Error?] = []
        sut.load { capturedErrors.append($0) }
        
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        client.complete(with: error)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        var capturedErrors: [RemoteFeedLoader.Error?] = []
        sut.load { capturedErrors.append($0) }
        
        client.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    private func makeSUT(with url: URL = URL(string: "http://custom-url.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestURLs: [URL] {
            messages.map { $0.url }
        }
        
        private var messages: [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)] = []
        
        func getFrom(url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error?, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode statusCode: Int, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
            messages[index].completion(nil, response)
        }
    }
    
}
