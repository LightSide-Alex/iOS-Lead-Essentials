//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-04.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    public typealias Result = LoadFeedResult
    
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
    
    public func load(completion: @escaping (Result) -> Void) {
        client.getFrom(url: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data, let response):
                completion(Self.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
    }
}
