//
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-07-04.
//

import XCTest
import EssentialFeed

class FeedEndpointTests: XCTestCase {

    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!

        XCTAssertEqual(received, expected)
    }

}
