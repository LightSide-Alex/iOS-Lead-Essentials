//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-29.
//

import XCTest
import EssentialFeed

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
    
    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        
        expect(sut: sut, toRetrieve: .success(foundData)) {
            store.completeRetrieve(with: .success(foundData))
        }
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        
        var received = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: anyURL()) { received.append($0) }
        task.cancel()
        
        store.completeRetrieve(with: .success(foundData))
        store.completeRetrieve(with: .success(.none))
        store.completeRetrieve(with: .failure(anyNSError()))
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        var (sut, store): (LocalFeedImageDataLoader?, FeedImageDataStoreSpy) = makeSUT()
        let foundData = anyData()
        
        var received = [FeedImageDataLoader.Result]()
        _ = sut?.loadImageData(from: anyURL()) { received.append($0) }
        sut = nil
        
        store.completeRetrieve(with: .success(foundData))
        store.completeRetrieve(with: .success(.none))
        store.completeRetrieve(with: .failure(anyNSError()))
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after instance was deallocated")
    }
    
    func test_saveImageDataForURL_requestsDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let dataToInsert = anyData()
        let insertURL = anyURL()
        
        sut.save(dataToInsert, for: insertURL) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: dataToInsert, for: insertURL)])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let storeSpy = FeedImageDataStoreSpy()
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
            case (let .failure(receivedError as LocalFeedImageDataLoader.LoadError),
                      let .failure(expectedError as LocalFeedImageDataLoader.LoadError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: LocalFeedImageDataLoader.LoadError) -> FeedImageDataStore.RetrievalResult {
        return .failure(error)
    }
}
