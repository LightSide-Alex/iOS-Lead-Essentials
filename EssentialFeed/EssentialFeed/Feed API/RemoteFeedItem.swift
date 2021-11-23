//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-10-28.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
