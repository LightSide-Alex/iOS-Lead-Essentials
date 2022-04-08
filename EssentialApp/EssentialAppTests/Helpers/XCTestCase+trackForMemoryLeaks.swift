//
//  XCTestCase+trackForMemoryLeaks.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-07.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
