//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-29.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    typealias RetrievalResult = Result<Data?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func retrieve(dataForURL url: URL, completion: @escaping RetrievalCompletion)
}

class LocalFeedImageDataLoader: FeedImageDataLoader {
    private struct Task: FeedImageDataLoaderTask {
        func cancel() { }
    }
    enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    private let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        store.retrieve(dataForURL: url) { result in
            switch result {
            case .success: completion(.failure(Error.notFound))
            case .failure: completion(.failure(Error.failed))
            }
        }
        return Task()
    }
}

class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageData_requestsImageByUrl() {
        let (sut, store) = makeSUT()
        let requestUrl = anyURL()
        
        _ = sut.loadImageData(from: requestUrl) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: requestUrl)])
    }
    
    func test_loadImageData_failsOnStoreError() {
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toRetrieve: failure(.failed)) {
            store.completeRetrieve(with: .failure(anyNSError()))
        }
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toRetrieve: failure(.notFound)) {
            store.completeRetrieve(with: .success(.none))
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let storeSpy = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: storeSpy)
        trackMemoryLeak(for: storeSpy, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, storeSpy)
    }
    
    private func expect(sut: LocalFeedImageDataLoader,
                        toRetrieve expectedResult: FeedImageDataStore.RetrievalResult,
                        when action: @escaping () -> Void,
                        file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for completion")
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (let .success(received), let .success(expected)):
                XCTAssertEqual(received, expected, file: file, line: line)
            case (let .failure(receivedError as LocalFeedImageDataLoader.Error),
                      let .failure(expectedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: LocalFeedImageDataLoader.Error) -> FeedImageDataStore.RetrievalResult {
        return .failure(error)
    }
    
    private final class FeedStoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        var receivedMessages: [Message] = []
        
        private var retrieveCompletions: [RetrievalCompletion] = []
        func retrieve(dataForURL url: URL, completion: @escaping RetrievalCompletion) {
            receivedMessages.append(.retrieve(dataFor: url))
            retrieveCompletions.append(completion)
        }
        func completeRetrieve(with result: RetrievalResult, at index: Int = 0) {
            retrieveCompletions[index](result)
        }
    }
}
