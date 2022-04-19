//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-13.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.loadedImageURLs.isEmpty)
    }
    
    func test_loadImageData_loadsFromLoader() {
        let url = anyURL()
        let (sut, loader) = makeSUT()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loadedImageURLs, [url], "Expected to load URL from loader")
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let url = anyURL()
        let (sut, loader) = makeSUT()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(loader.cancelledImageURLs, [url], "Expected to cancel URL loading from loader")
    }
    
    func test_load_deliversSuccessOnLoadSuccess() {
        let (sut, loader) = makeSUT()
        let successData = anyData()
        
        expect(sut, toCompleteWith: .success(successData)) {
            loader.completeImageLoading(with: successData)
        }
    }
    
    func test_load_deliversErrorOnLoadFailure() {
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError())) {
            loader.completeImageLoadingWithError()
        }
    }
    
    func test_load_cachesDataOnLoadSuccess() {
        let cacheSpy = CacheSpy()
        let (sut, loader) = makeSUT(cache: cacheSpy)
        let loadURL = anyURL()
        let successData = anyData()
        
        _ = sut.loadImageData(from: loadURL) { _ in }
        loader.completeImageLoading(with: successData)
        
        XCTAssertEqual(cacheSpy.messages, [.save(data: successData, for: loadURL)])
    }
    
    func test_loadImageData_doesNotCacheDataOnLoaderFailure() {
        let cache = CacheSpy()
        let url = anyURL()
        let (sut, loader) = makeSUT(cache: cache)
        
        _ = sut.loadImageData(from: url) { _ in }
        loader.completeImageLoadingWithError()
        
        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache image data on load error")
    }
    
    // MARK: - Helpers
    private func makeSUT(cache: CacheSpy = .init(),
                         file: StaticString = #file,
                         line: UInt = #line) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(data: Data, for: URL)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data: data, for: url))
            completion(.success(()))
        }
    }
}
