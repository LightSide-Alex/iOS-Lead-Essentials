//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-04-04.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result(catching: {
                try ManagedCache.find(in: context).map({ cache in
                    CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp)
                })
            }))
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result(catching: {
                try ManagedCache.deleteCache(in: context)
            }))
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result(catching: {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                try context.save()
            }))
        }
    }
}
