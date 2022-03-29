//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-29.
//

import XCTest
import EssentialFeed

class LocalFeedImageDataLoader {
    init(store: Any) {}
}


class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let storeSpy = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: storeSpy)
        trackMemoryLeak(for: storeSpy, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, storeSpy)
    }
    
    private final class FeedStoreSpy {
        var receivedMessages: [Any] = []
    }
}
