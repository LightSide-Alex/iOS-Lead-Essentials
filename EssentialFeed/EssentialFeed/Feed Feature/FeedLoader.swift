//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-08-31.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
