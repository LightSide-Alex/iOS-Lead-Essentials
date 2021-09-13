//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-12.
//

import Foundation

struct FeedItemsMapper {
    private struct Root: Codable {
        let items: [CFeedItem]
    }
    
    private struct CFeedItem: Codable {
        let id: UUID
        let description: String?
        let location: String?
        let imageURL: URL
        
        var item: FeedItem {
            FeedItem(id: id, description: description, location: location, image: imageURL)
        }
    }
    
    private static var OK_200: Int {
        return 200
    }
    
    static func mapData(_ data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw NSError()
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
}
