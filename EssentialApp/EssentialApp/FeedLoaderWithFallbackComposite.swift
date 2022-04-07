//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Oleksandr Balan on 2022-04-07.
//

import Foundation
import EssentialFeed

public class FeedLoaderWithFallbackComposite: FeedLoader {
    let primary: FeedLoader
    let fallback: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load { [weak self] primaryLoadResult in
            switch primaryLoadResult {
            case .success:
                completion(primaryLoadResult)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
