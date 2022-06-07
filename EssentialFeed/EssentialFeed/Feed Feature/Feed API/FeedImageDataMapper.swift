//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-06-06.
//

import Foundation

public final class FeedImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOk, !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
