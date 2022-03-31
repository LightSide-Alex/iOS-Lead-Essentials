//
//  XCTestCase+TrackMemoryLeak.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-23.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(for instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) should be deallocated after function ends", file: file, line: line)
        }
    }
}
