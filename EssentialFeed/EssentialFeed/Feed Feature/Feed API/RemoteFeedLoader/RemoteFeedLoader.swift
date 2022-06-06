//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-04.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>
public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(
            url: url,
            client: client,
            mapper: FeedItemsMapper.map
        )
    }
}
extension RemoteFeedLoader: FeedLoader {}