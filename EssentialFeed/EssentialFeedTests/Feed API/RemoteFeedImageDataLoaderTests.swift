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
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.getFrom(url: url) { result in
            switch result {
            case let .failure(error): completion(.failure(error))
            default: break
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
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            spy.complete(with: expectedError)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, view: HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: clientSpy)
        trackMemoryLeak(for: clientSpy, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, clientSpy)
    }
    
    private func expect(_ sut: RemoteFeedImageDataLoader,
                        toCompleteWith expectedResult: FeedImageDataLoader.Result,
                        on action: () -> Void,
                        file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for completion")
        sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
