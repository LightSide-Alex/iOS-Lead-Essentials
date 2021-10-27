//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-10-27.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCacheFeed(completion: { [weak self] cacheDeletionError in
            guard let self = self else { return }
            if let cacheDeletionError = cacheDeletionError {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        })
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items, timestamp: currentDate(), completion: { [weak self] insertionError in
            guard self != nil else { return }
            completion(insertionError)
        })
    }
}
