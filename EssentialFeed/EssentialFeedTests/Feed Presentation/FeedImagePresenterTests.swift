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
    private let imageTransformer: (Data) -> Any?
    
    init(view: FeedImageView, imageTransformer: @escaping (Data) -> Any?) {
        self.view = view
        self.imageTransformer = imageTransformer
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
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: false,
            shouldRetry: true
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
        let model = view.messages.first
        XCTAssertEqual(model?.description, image.description)
        XCTAssertEqual(model?.location, image.location)
        XCTAssertEqual(model?.isLoading, true)
        XCTAssertEqual(model?.shouldRetry, false)
        XCTAssertNil(model?.image)
    }
    
    func test_didFinishLoadingImageData_displaysRetryErrorIfImageTransformationFails() {
        let (sut, view) = makeSUT(imageTransformer: fail)
        let image = uniqueImage()
        
        sut.didFinishLoadingImageData(with: anyImageData(), for: image)
        
        XCTAssertEqual(view.messages.count, 1)
        let model = view.messages.first
        XCTAssertEqual(model?.description, image.description)
        XCTAssertEqual(model?.location, image.location)
        XCTAssertEqual(model?.isLoading, false)
        XCTAssertEqual(model?.shouldRetry, true)
        XCTAssertNil(model?.image)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        imageTransformer: @escaping (Data) -> Any? = { _ in nil },
        file: StaticString = #file,
        line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
            let view = ViewSpy()
            let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
            trackMemoryLeak(for: view, file: file, line: line)
            trackMemoryLeak(for: sut, file: file, line: line)
            return (sut, view)
        }
    
    private final class ViewSpy: FeedImageView {
        var messages = [FeedImageViewModel]()
        
        func display(_ model: FeedImageViewModel) {
            messages.append(model)
        }
    }
    
    private func anyImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private var fail: (Data) -> Any? {
        return { _ in nil }
    }
}
