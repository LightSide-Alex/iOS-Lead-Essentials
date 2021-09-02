//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-01.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.getFrom(url: URL(string: "http://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func getFrom(url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestURL: URL?
    
    override func getFrom(url: URL) {
        requestURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_RequestDataOnLoad() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        let sut = RemoteFeedLoader()
        sut.load()
        
        XCTAssertEqual(client.requestURL, URL(string: "http://a-url.com")!)
    }
}
