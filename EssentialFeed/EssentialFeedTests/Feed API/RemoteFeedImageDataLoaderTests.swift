//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-23.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    private struct HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        let wrapped: HTTPClientTask
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    @discardableResult
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return HTTPClientTaskWrapper(wrapped: client.getFrom(url: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, !data.isEmpty {
                    completion(.success(data))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
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
                view.complete(withStatusCode: code, data: anyData(), at: index)
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
    
    func test_loadImageData_deliversNonEmptyDataOn200Reposnse() {
        let (sut, view) = makeSUT()
        let nonEmptyData = Data("Non empty data".utf8)
        
        expect(sut, toCompleteWith: .success(nonEmptyData)) {
            view.complete(withStatusCode: 200, data: nonEmptyData)
        }
    }
    
    func test_loadImageData_doesNotDeliverResultAfterInstanceWasDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteFeedImageDataLoader? = RemoteFeedImageDataLoader(client: client)

        var capturedResults = [FeedImageDataLoader.Result]()
        sut?.loadImageData(from: anyURL()) { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: anyData())

        XCTAssertTrue(capturedResults.isEmpty)
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
    
    private func anyData() -> Data {
        return Data("Any data".utf8)
    }
}
