//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-10-28.
//

import Foundation

public struct LocalFeedItem: Equatable {
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
