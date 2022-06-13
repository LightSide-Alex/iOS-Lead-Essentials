//
//  LoadResourcePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-06-09.
//

import XCTest
import EssentialFeed

class LoadResourcePresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessageAndLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: nil),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingFeedWithFeed_stopsLoadingAndDisplaysFeed() {
        let resource = "Any resource"
        let (sut, view) = makeSUT { inputResource in
            return inputResource + " mapped"
        }
        
        sut.didFinishLoading(with: resource)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(viewModel: "\(resource) mapped")
        ])
    }
    
    func test_didFinishLoadingFeedWithError_stopsLoadingAndDisplaysErrorMessage() {
        let (sut, view) = makeSUT()
        let error = anyNSError()
        
        sut.didFinishLoading(with: error)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(errorMessage: localized("GENERIC_CONNECTION_ERROR"))
        ])
    }
    
    func test_didFinishLoadingWithMapperError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            throw anyNSError()
        })
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("GENERIC_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    private func makeSUT(
        mapper: @escaping (String) throws -> String = { _ in "Any" },
        file: StaticString = #file,
        line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
            let view = ViewSpy()
            let sut = SUT(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
            trackForMemoryLeaks(for: view, file: file, line: line)
            trackForMemoryLeaks(for: sut, file: file, line: line)
            return (sut, view)
        }
    
    private final class ViewSpy: ResourceErrorView, ResourceLoadingView, ResourceView {
        typealias ResourceViewModel = String
        
        enum ReceivedMessages: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(viewModel: String)
        }
        
        var messages = Set<ReceivedMessages>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: ResourceViewModel) {
            messages.insert(.display(viewModel: viewModel))
        }
    }
    
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Shared"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
