//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-04.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case error(Error)
}

public protocol HTTPClient {
    func getFrom(url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

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
        client.getFrom(url: url) { result in
            switch result {
            case .success(let data, let response):
                if response.statusCode == 200,
                   let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.items.map { $0.item }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .error:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Codable {
    let items: [CFeedItem]
}

private struct CFeedItem: Codable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
    
    var item: FeedItem {
        FeedItem(
            id: id,
            description: description,
            location: location,
            image: imageURL
        )
    }
}
