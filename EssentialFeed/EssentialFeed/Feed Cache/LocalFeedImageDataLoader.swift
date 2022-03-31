//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-30.
//

import Foundation

public class LocalFeedImageDataLoader {
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    private final class LoadImageDataTask: FeedImageDataLoaderTask {
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
    
    public typealias LoadResult = FeedImageDataLoader.Result
    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion: completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                            .mapError { _ in LoadError.failed }
                            .flatMap { data in data.map { .success($0) } ?? .failure(LoadError.notFound) })
        }
        return task
    }
}

public extension LocalFeedImageDataLoader {
    typealias SaveResult = Result<Void, Swift.Error>
    enum SaveError: Error {
        case failed
    }
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { result in
            completion(result.mapError { _ in SaveError.failed })
        }
    }
}
