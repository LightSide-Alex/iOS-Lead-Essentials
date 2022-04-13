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

class FeedLoaderCacheDecoratorTests: XCTestCase {
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
    
    private func expect(_ sut: FeedLoaderCacheDecorator,
                        toCompleteWith expectedResult: FeedLoader.Result,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Waiting for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case (let .success(receivedFeed), let .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
            case (let .failure(receivedError as NSError), let .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError.code, expectedError.code, file: file, line: line)
                XCTAssertEqual(receivedError.domain, expectedError.domain, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func uniqueImageFeed() -> [FeedImage] {
        return [uniqueImage(), uniqueImage()]
    }
    
    private func uniqueImage() -> FeedImage {
        FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }
}
