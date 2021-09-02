//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-01.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.getFrom(url: url)
    }
}

protocol HTTPClient {
    func getFrom(url: URL)
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_requestDataFromURL() {
        let url = URL(string: "http://custom-url.com")!
        let (sut, client) = makeSUT(with: url)
        sut.load()
        
        XCTAssertEqual(client.requestURL, url)
    }
    
    private func makeSUT(with url: URL = URL(string: "http://a-url.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestURL: URL?
        
        func getFrom(url: URL) {
            requestURL = url
        }
    }
    
}
