//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Oleksandr Balan on 2021-12-20.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for load result")
        
        sut.load { result in
            switch result {
            case let .success(imageFeed):
                XCTAssertEqual(imageFeed, [], "Expected empty feed")
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        let coreDataStore = try! CoreDataFeedStore(storeURL: storeURL, bundle: bundle)
        let sut = LocalFeedLoader(store: coreDataStore, currentDate: Date.init)
        trackMemoryLeak(for: sut, file: file, line: line)
        trackMemoryLeak(for: coreDataStore, file: file, line: line)
        
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
