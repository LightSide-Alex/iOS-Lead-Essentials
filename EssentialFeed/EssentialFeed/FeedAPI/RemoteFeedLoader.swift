//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-04.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.getFrom(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data, let response):
                completion(self.map(data, response))
            case .error:
                completion(.failure(.connectivity))
            }
        }
    }
    
    func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        do {
            let items = try FeedItemsMapper.mapData(data, response: response)
            return .success(items)
        } catch {
            return .failure(.invalidData)
        }
    }
}
