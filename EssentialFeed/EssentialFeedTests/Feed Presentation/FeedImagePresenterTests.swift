//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-17.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
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
        let image = imageTransformer(data)
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: image == nil
        ))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
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
        
        sut.didFinishLoadingImageData(with: Data(), for: image)
        
        XCTAssertEqual(view.messages.count, 1)
        let model = view.messages.first
        XCTAssertEqual(model?.description, image.description)
        XCTAssertEqual(model?.location, image.location)
        XCTAssertEqual(model?.isLoading, false)
        XCTAssertEqual(model?.shouldRetry, true)
        XCTAssertNil(model?.image)
    }
    
    func test_didFinishLoadingImageData_displaysImageIfTransformationSucceeds() {
        let image = uniqueImage()
        let data = Data()
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        
        sut.didFinishLoadingImageData(with: data, for: image)
        
        XCTAssertEqual(view.messages.count, 1)
        let model = view.messages.first
        XCTAssertEqual(model?.description, image.description)
        XCTAssertEqual(model?.location, image.location)
        XCTAssertEqual(model?.isLoading, false)
        XCTAssertEqual(model?.shouldRetry, false)
        XCTAssertEqual(model?.image, transformedData)
    }
    
    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let (sut, view) = makeSUT(imageTransformer: fail)
        let image = uniqueImage()
        
        sut.didFinishLoadingImageData(with: anyNSError(), for: image)
        
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
        imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
        file: StaticString = #file,
        line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
            let view = ViewSpy()
            let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
            trackMemoryLeak(for: view, file: file, line: line)
            trackMemoryLeak(for: sut, file: file, line: line)
            return (sut, view)
        }
    
    private final class ViewSpy: FeedImageView {
        var messages = [FeedImageViewModel<AnyImage>]()
        
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }
    
    private var fail: (Data) -> AnyImage? {
        return { _ in nil }
    }
    
    private struct AnyImage: Equatable {}
}
