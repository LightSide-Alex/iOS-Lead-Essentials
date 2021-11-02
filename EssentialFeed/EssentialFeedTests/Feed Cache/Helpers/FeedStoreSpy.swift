//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-11-02.
//

import EssentialFeed

final class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case retrieve
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    private var retrievalCompletions: [RetrievalCompletion] = []
    private var deletionCompletions: [DeletionCompletion] = []
    private var insertionCompletions: [InsertionCompletion] = []
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](nil)
    }
}
