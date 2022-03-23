//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-23.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    private let client: Any
    
    init(client: Any) {
        self.client = client
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformURLRequests() {
        let (_, spy) = makeSUT()
        
        XCTAssertTrue(spy.messages.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, view: ClientSpy) {
        let clientSpy = ClientSpy()
        let sut = RemoteFeedImageDataLoader(client: clientSpy)
        trackMemoryLeak(for: clientSpy, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, clientSpy)
    }
    
    private final class ClientSpy {
        var messages: [Any] = []
    }
}
