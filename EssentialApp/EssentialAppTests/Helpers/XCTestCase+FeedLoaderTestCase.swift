//
//  XCTestCase+FeedLoaderTestCase.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-13.
//

import XCTest
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
    func expect(_ sut: FeedLoader,
                toCompleteWith expectedResult: FeedLoader.Result,
                file: StaticString = #file,
                line: UInt = #line) {
        let exp = expectation(description: "Waiting for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case (let .success(receivedFeed), let .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
            case (let .failure(receivedError as NSError), let .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError.code, expectedError.code, file: file, line: line)
                XCTAssertEqual(receivedError.domain, expectedError.domain, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
