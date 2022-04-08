//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-07.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    func test_init_doesNotLoadImageData() {
        let (_, primaryLoader, fallbackLoader) = makeSUT()
        
        XCTAssertTrue(primaryLoader.loadedImageURLs.isEmpty)
        XCTAssertTrue(fallbackLoader.loadedImageURLs.isEmpty)
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryLoader.loadedImageURLs, [url], "Expected to load URL from primary loader")
        XCTAssertTrue(fallbackLoader.loadedImageURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromFallbackOnPrimaryLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        primaryLoader.completeImageLoadingWithError()
        
        XCTAssertEqual(primaryLoader.loadedImageURLs, [url], "Expected to load URL from primary loader")
        XCTAssertEqual(fallbackLoader.loadedImageURLs, [url], "Expected to load URL from fallback loader when primary completes with an error")
    }
    
    func test_cancelLoadImageData_cancelsPrimaryLoaderTask() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primaryLoader.cancelledImageURLs, [url], "Expected to cancel URL from primary loader")
        XCTAssertTrue(fallbackLoader.cancelledImageURLs.isEmpty, "Expected no cancelled URLs in the fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsFallbackLoaderTaskAfterPrimaryLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        primaryLoader.completeImageLoadingWithError()
        task.cancel()
        
        XCTAssertTrue(primaryLoader.cancelledImageURLs.isEmpty, "Expected no cancelled URLs in the primary loader")
        XCTAssertEqual(fallbackLoader.cancelledImageURLs, [url], "Expected to cancel URL from fallback loader")
    }
    
    func test_loadImageData_deliversPrimaryDataOnPrimaryLoaderSuccess() {
        let (sut, primaryLoader, _) = makeSUT()
        let primaryResult = anyData()
        
        expect(sut, toCompleteWith: .success(primaryResult)) {
            primaryLoader.completeImageLoading(with: primaryResult)
        }
    }
    
    func test_loadImageData_deliversFallbackDataOnFallbackLoaderSuccess() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let fallbackResult = anyData()
        
        expect(sut, toCompleteWith: .success(fallbackResult)) {
            primaryLoader.completeImageLoadingWithError()
            fallbackLoader.completeImageLoading(with: fallbackResult)
        }
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError())) {
            primaryLoader.completeImageLoadingWithError()
            fallbackLoader.completeImageLoadingWithError()
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, primary: LoaderSpy, fallback: LoaderSpy) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        
        return (sut, primaryLoader, fallbackLoader)
    }
    
    private func expect(_ sut: FeedImageDataLoader,
                        toCompleteWith expectedResult: FeedImageDataLoader.Result,
                        on action: @escaping () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Waiting for loading completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (let .success(receivedData), let .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func anyData() -> Data {
        return Data("Any data".utf8)
    }
}
