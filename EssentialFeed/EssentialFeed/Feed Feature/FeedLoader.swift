//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-08-31.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable {}

public protocol FeedLoader {
    
    func loadFeed(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
