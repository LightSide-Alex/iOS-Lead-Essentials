//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Oleksandr Balan on 2022-04-20.
//

import XCTest

class EssentialAppUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
        let cells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(cells.count, 22)
        
        let image = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(image.exists)
    }
}
