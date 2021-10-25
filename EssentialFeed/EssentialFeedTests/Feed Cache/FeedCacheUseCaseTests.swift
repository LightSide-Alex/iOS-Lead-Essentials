//
//  FeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-10-25.
//

import XCTest
import EssentialFeed

final class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCacheFeed()
    }
}

final class FeedStore {
    private(set) var deleteCacheFeedCount = 0
    
    func deleteCacheFeed() {
        deleteCacheFeedCount += 1
    }
}

class FeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCacheFeedCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let store = FeedStore()
        let loader = LocalFeedLoader(store: store)
        let items = [uniqueItem(), uniqueItem()]
        loader.save(items)
        
        XCTAssertEqual(store.deleteCacheFeedCount, 1)
    }
    
    // MARK: Helpers
    private func uniqueItem() -> FeedItem {
        FeedItem(id: UUID(), description: "any", location: "any", image: anyURL())
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
}
