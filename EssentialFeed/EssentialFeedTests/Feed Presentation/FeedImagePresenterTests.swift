//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-17.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {
    }
}

class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let view = ViewSpy()
        _ = FeedImagePresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private final class ViewSpy {
        var messages = [Any]()
    }
}
