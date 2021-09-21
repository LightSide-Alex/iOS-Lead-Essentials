//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-20.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask
}

protocol HTTPSessionDataTask {
    func resume()
}

final class URLSessionHTTPClient: HTTPClient {
    let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func getFrom(url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromUrl_resumesDataTaskWithURL() {
        let dataTask = URLSessionDataTaskSpy()
        let session = HTTPSessionSpy()
        let url = URL(string: "http://a-url.com")!
        session.stub(url: url, with: HTTPSessionSpy.Stub(dataTask: dataTask))
        let sut = URLSessionHTTPClient(session: session)
        
        sut.getFrom(url: url) { _ in }
        
        XCTAssertEqual(1, dataTask.resumeCallCount)
    }
    
    func test_getFromUrl_deliversFailureOnRequestError() {
        let session = HTTPSessionSpy()
        let url = URL(string: "http://a-url.com")!
        let error = NSError(domain: "any error", code: 0, userInfo: nil)
        let stub = HTTPSessionSpy.Stub(dataTask: URLSessionDataTaskSpy(), data: nil, response: nil, error: error)
        session.stub(url: url, with: stub)
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for getFrom result")
        sut.getFrom(url: url) { result in
            switch result {
            case .failure(let receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure but got \(result) instead")
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

private extension URLSessionHTTPClientTests {
    
    final class HTTPSessionSpy: HTTPSession {
        private var stubs: [URL: Stub] = [:]
        
        struct Stub {
            var dataTask: HTTPSessionDataTask
            var data: Data?
            var response: URLResponse?
            var error: Error?
        }
        
        func stub(url: URL, with stub: Stub) {
            stubs[url] = stub
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            
            completionHandler(stub.data, stub.response, stub.error)
            return stub.dataTask
        }
    }
    
    final class URLSessionDataTaskSpy: HTTPSessionDataTask {
        var resumeCallCount = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
