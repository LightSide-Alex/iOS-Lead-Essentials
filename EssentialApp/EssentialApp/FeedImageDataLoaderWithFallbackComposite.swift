//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Oleksandr Balan on 2022-04-08.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    final class Task: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    let primary: FeedImageDataLoader
    let fallback: FeedImageDataLoader
    
    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task()
        task.wrapped = primary.loadImageData(from: url) { [weak self] primaryLoadResult in
            switch primaryLoadResult {
            case .success:
                completion(primaryLoadResult)
            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
        
        return task
    }
}
