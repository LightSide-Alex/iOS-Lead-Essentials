//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-12.
//

import Foundation

internal struct RemoteFeedItem: Codable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

struct FeedItemsMapper {
    private struct Root: Codable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int {
        return 200
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
                  throw RemoteFeedLoader.Error.invalidData
              }
        
        return root.items
    }
    
}
