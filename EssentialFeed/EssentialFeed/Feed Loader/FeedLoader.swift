//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-08-31.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func loadFeed(completion: @escaping (LoadFeedResult) -> Void)
}
