//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-30.
//

import Foundation

public class LocalFeedImageDataLoader: FeedImageDataLoader {
    public typealias SaveResult = Result<Void, Swift.Error>
    
    private final class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventCompletions()
        }
        
        private func preventCompletions() {
            completion = nil
        }
    }
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion: completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                            .mapError { _ in Error.failed }
                            .flatMap { data in data.map { .success($0) } ?? .failure(Error.notFound) })
        }
        return task
    }

    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { _ in }
    }
}
