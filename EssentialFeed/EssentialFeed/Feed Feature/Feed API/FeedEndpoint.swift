//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-07-04.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
