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
    
    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
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
    
    // MARK: - Helpers
    private func makeSUT(with result: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoaderCacheDecorator {
        let loader = FeedLoaderStub(completionResult: result)
        let sut = FeedLoaderCacheDecorator(decoratee: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
