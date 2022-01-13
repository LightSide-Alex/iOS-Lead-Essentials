//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Balan on 2022-01-13.
//

import XCTest
import EssentialFeed
import UIKit

final class FeedViewController: UIViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load(completion: { _ in })
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, spy: LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = FeedViewController(loader: loaderSpy)
        
        trackMemoryLeak(for: loaderSpy, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        
        return (sut, loaderSpy)
    }
    
    class LoaderSpy: FeedLoader {
        var loadCallCount: Int { loadCompletions.count }
        private(set) var loadCompletions: [(FeedLoader.Result) -> Void] = []
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCompletions.append(completion)
        }
        func completeLoad(at index: Int = 0, with result: FeedLoader.Result) {
            loadCompletions[index](result)
        }
    }
}
