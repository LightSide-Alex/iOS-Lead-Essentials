//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-20.
//

import XCTest

final class URLSessionHTTPClient {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping () -> Void) {
        session.dataTask(with: url) { data, response, error in
            
        }.resume()
    }
    
}


class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromUrl_createsDataTaskWithURL() {
        let spy = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: spy)
        let url = URL(string: "http://a-url.com")!
        sut.get(from: url) { }
        
        XCTAssertEqual(spy.url, url)
    }
    
}

private extension URLSessionHTTPClientTests {
    
    final class URLSessionSpy: URLSession {
        var url: URL?

        override init() {}

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url

            return URLSessionDataTaskSpy()
        }
    }
    
    final class URLSessionDataTaskSpy: URLSessionDataTask {
        override func resume() {}
    }
}
