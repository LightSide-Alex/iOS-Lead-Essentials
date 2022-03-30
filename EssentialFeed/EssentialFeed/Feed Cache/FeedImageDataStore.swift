//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-30.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Result<Data?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func retrieve(dataForURL url: URL, completion: @escaping RetrievalCompletion)
}
