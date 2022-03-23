//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-23.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (Error?) -> Void) {
        client.getFrom(url: url) { result in
            if case let .failure(error) = result {
                completion(error)
            }
        }
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformURLRequests() {
        let (_, spy) = makeSUT()
        
        XCTAssertTrue(spy.requestURLs.isEmpty)
    }
    
    func test_loadImageData_requestsDataFromGivenURL() {
        let (sut, spy) = makeSUT()
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(spy.requestURLs, [requestURL])
    }
    
    func test_loadImageData_requestsDataFromURLTwiceWhenInvokedTwice() {
        let (sut, spy) = makeSUT()
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(spy.requestURLs, [requestURL, requestURL])
    }
    
    func test_loadImageData_deliversErrorOnClientError() {
        let (sut, spy) = makeSUT()
        let expectedError = anyNSError()
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: NSError?
        sut.loadImageData(from: anyURL()) { error in
            receivedError = error as NSError?
            exp.fulfill()
        }
        spy.complete(with: expectedError)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError, expectedError)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, view: HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: clientSpy)
        trackMemoryLeak(for: clientSpy, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, clientSpy)
    }
}
