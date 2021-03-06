//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-04-13.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
