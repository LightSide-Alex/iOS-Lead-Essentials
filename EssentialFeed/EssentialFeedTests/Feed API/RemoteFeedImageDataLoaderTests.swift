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
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.getFrom(url: url) { result in
            switch result {
            case let .success((data, response)):
                guard response.statusCode == 200, !data.isEmpty else {
                    completion(.failure(Error.invalidData))
                    return
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformURLRequests() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.requestURLs.isEmpty)
    }
    
    func test_loadImageData_requestsDataFromGivenURL() {
        let (sut, view) = makeSUT()
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(view.requestURLs, [requestURL])
    }
    
    func test_loadImageData_requestsDataFromURLTwiceWhenInvokedTwice() {
        let (sut, view) = makeSUT()
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(view.requestURLs, [requestURL, requestURL])
    }
    
    func test_loadImageData_deliversErrorOnClientError() {
        let (sut, view) = makeSUT()
        let expectedError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            view.complete(with: expectedError)
        }
    }
    
    func test_loadImageData_deliversInvalidDataErrorOnNon200Response() {
        let (sut, view) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                view.complete(withStatusCode: code, data: Data(), at: index)
            }
        }
    }
    
    func test_loadImageData_deliversInvalidDataErrorOnEmptyData() {
        let (sut, view) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let emptyData = Data()
            view.complete(withStatusCode: 200, data: emptyData)
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
    
    private func failure(_ error: RemoteFeedImageDataLoader.Error) -> FeedImageDataLoader.Result {
        return .failure(error)
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
            case let (.failure(receivedError as RemoteFeedImageDataLoader.Error), .failure(expectedError as RemoteFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
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
