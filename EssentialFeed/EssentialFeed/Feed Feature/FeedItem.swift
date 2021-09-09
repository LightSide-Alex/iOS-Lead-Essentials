//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-08-30.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let image: URL
    
    public init(id: UUID, description: String?, location: String?, image: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.image = image
    }
}

extension FeedItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case image = "imageURL"
    }
}
