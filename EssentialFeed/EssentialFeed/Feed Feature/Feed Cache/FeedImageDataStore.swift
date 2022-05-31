//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-30.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Result<Data?, Error>    
    typealias InsertionResult = Result<Void, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}
