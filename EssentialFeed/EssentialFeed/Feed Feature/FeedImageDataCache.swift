//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-04-19.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
