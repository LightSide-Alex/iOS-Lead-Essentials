//
//  XCTestCase+UniqueFeed.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-13.
//

import XCTest
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
    func uniqueImageFeed() -> [FeedImage] {
        return [uniqueImage(), uniqueImage()]
    }
    
    func uniqueImage() -> FeedImage {
        FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }
}
