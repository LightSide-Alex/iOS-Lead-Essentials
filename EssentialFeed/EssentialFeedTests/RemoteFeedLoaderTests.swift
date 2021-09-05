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
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://custom-url.com")!
        let (sut, client) = makeSUT(with: url)
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    private func makeSUT(with url: URL = URL(string: "http://a-url.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestURLs: [URL] = []
        
        func getFrom(url: URL) {
            requestURLs.append(url)
        }
    }
    
}
