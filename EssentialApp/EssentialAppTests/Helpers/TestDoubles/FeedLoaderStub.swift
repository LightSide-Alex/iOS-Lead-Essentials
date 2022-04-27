//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-13.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let completionResult: FeedLoader.Result
    
    init(completionResult: FeedLoader.Result) {
        self.completionResult = completionResult
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(completionResult)
    }
}
