//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-16.
//

import XCTest

final class FeedPresenter {
    let view: Any
    
    init(view: Any) {
        self.view = view
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let spy = ViewSpy()
        _ = FeedPresenter(view: spy)
        
        XCTAssertTrue(spy.receviedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private final class ViewSpy {
        var receviedMessages = [Any]()
    }
}
