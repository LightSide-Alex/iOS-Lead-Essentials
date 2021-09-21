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
    func test_getFromUrl_resumesDataTaskWithURL() {
        let dataTask = URLSessionDataTaskSpy()
        let session = URLSessionSpy()
        let url = URL(string: "http://a-url.com")!
        session.stub(url: url, with: dataTask)
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { }
        
        XCTAssertEqual(1, dataTask.resumeCallCount)
    }
}

private extension URLSessionHTTPClientTests {
    
    final class URLSessionSpy: URLSession {
        private var stubs: [URL: URLSessionDataTask] = [:]
        
        override init() {}
        
        func stub(url: URL, with dataTask: URLSessionDataTask) {
            stubs[url] = dataTask
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return stubs[url] ?? URLSessionDataTaskSpy()
        }
    }
    
    final class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
