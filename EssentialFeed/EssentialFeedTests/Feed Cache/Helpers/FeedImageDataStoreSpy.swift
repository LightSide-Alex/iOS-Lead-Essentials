//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-03-31.
//

import EssentialFeed

final class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    var receivedMessages: [Message] = []
    
    private var retrieveCompletions: [RetrievalCompletion] = []
    func retrieve(dataForURL url: URL, completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrieveCompletions.append(completion)
    }
    func completeRetrieve(with result: RetrievalResult, at index: Int = 0) {
        retrieveCompletions[index](result)
    }
    
    private var insertCompletions: [InsertionCompletion] = []
    func insert(_ data: Data, for url: URL, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(data: data, for: url))
        insertCompletions.append(completion)
    }
    func completeInsert(with result: InsertionResult, at index: Int = 0) {
        insertCompletions[index](result)
    }
}
