//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-17.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let image: Any?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    func display(_ model: FeedImageViewModel)
}

final class FeedImagePresenter {
    private let view: FeedImageView
    
    init(view: FeedImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false
        ))
    }
}

class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()
        
        sut.didStartLoadingImageData(for: image)
        
        XCTAssertEqual(view.messages.count, 1)
        if case let .display(model) = view.messages.first {
            XCTAssertEqual(model.description, image.description)
            XCTAssertEqual(model.location, image.location)
            XCTAssertEqual(model.isLoading, true)
            XCTAssertEqual(model.shouldRetry, false)
            XCTAssertNil(model.image)
        } else {
            XCTFail("Expected to receive display(model) message, but got \(view.messages) instead")
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackMemoryLeak(for: view, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, view)
    }
    
    private final class ViewSpy: FeedImageView {
        enum ReceivedMessages {
            case display(model: FeedImageViewModel)
        }
        
        var messages = [ReceivedMessages]()
        
        func display(_ model: FeedImageViewModel) {
            messages.append(.display(model: model))
        }
    }
}
