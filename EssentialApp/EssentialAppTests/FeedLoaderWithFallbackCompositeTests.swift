//
//  FeedLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-07.
//

import XCTest
import EssentialFeed

class FeedLoaderWithFallbackComposite: FeedLoader {
    let primary: FeedLoader
    let fallback: FeedLoader
    
    init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load(completion: completion)
    }
}

class FeedLoaderWithFallbackCompositeTests: XCTestCase {
    func test_load_loadsFromPrimarySourceOnPrimarySuccess() {
        let primaryFeed = uniqueImageFeed()
        let fallbackFeed = uniqueImageFeed()
        let sut = makeSUT(primary: .success(primaryFeed), fallback: .success(fallbackFeed))
        let exp = expectation(description: "Waiting for completion")
        
        sut.load { receivedResult in
            switch receivedResult {
            case let .success(imageFeed):
                XCTAssertEqual(imageFeed, primaryFeed)
            case let .failure(error):
                XCTFail("Expected success, got \(error) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(primary: FeedLoader.Result, fallback: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoader {
        let primaryLoader = FeedLoaderStub(completionResult: primary)
        let fallbackLoader = FeedLoaderStub(completionResult: fallback)
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        return sut
    }
    
    private class FeedLoaderStub: FeedLoader {
        private let completionResult: FeedLoader.Result
        
        init(completionResult: FeedLoader.Result) {
            self.completionResult = completionResult
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(completionResult)
        }
    }
    
    private func uniqueImageFeed() -> [FeedImage] {
        return [uniqueImage(), uniqueImage()]
    }
    
    private func uniqueImage() -> FeedImage {
        FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "https://any-url.com")!)
    }
}
