//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-01.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestURL = URL(string: "http://a-url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    
    var requestURL: URL?
    
    private init() {}
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_RequestDataOnLoad() {
        let sut = RemoteFeedLoader()
        sut.load()
        
        XCTAssertEqual(HTTPClient.shared.requestURL, URL(string: "http://a-url.com")!)
    }
}
