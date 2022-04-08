//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-08.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
