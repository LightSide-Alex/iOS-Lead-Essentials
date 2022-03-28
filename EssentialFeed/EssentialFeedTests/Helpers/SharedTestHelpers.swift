//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-11-16.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    return Data("Any data".utf8)
}
