//
//  XCTestCase+TrackMemoryLeak.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-23.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(for instance: AnyObject, at file: StaticString = #file, _ line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) should be deallocated after function ends", file: file, line: line)
        }
    }
}
