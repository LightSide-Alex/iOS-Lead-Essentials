//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-04.
//

import Foundation

public protocol HTTPClient {
    func getFrom(url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error?) -> Void) {
        client.getFrom(url: url) { error, response in
            if error != nil {
                completion(.connectivity)
            } else {
                completion(.invalidData)
            }
        }
    }
}
