//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-13.
//

import XCTest
import EssentialFeed

final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.save(feed) { _ in }
                return feed
            })
        }
    }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
    func test_load_deliversFeedOnLoaderSuccess() {
        let loadSuccess: FeedLoader.Result = .success(uniqueImageFeed())
        let sut = makeSUT(with: loadSuccess)
        
        expect(sut, toCompleteWith: loadSuccess)
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let loadFailure: FeedLoader.Result = .failure(anyNSError())
        let sut = makeSUT(with: loadFailure)
        
        expect(sut, toCompleteWith: loadFailure)
    }
    
    func test_load_cachesLoadedFeedOnLoaderSuccess() {
        let cache = FeedCacheSpy()
        let feed = uniqueImageFeed()
        let sut = makeSUT(with: .success(feed), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.receivedMessages, [.save(feed)])
    }
    
    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = FeedCacheSpy()
        let sut = makeSUT(with: .failure(anyNSError()), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertTrue(cache.receivedMessages.isEmpty, "Expected not to cache feed on load error")
    }
    
    // MARK: - Helpers
    private func makeSUT(with result: FeedLoader.Result,
                         cache: FeedCache = FeedCacheSpy(),
                         file: StaticString = #file,
                         line: UInt = #line) -> FeedLoaderCacheDecorator {
        let loader = FeedLoaderStub(completionResult: result)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private final class FeedCacheSpy: FeedCache {
        enum Message: Equatable {
            case save([FeedImage])
        }
        private(set) var receivedMessages: [Message] = []
        
        func save(_ feed: [FeedImage], completion: @escaping (FeedCache.SaveResult) -> Void) {
            receivedMessages.append(.save(feed))
            completion(.success(()))
        }
    }
}
