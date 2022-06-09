//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Balan on 2022-02-22.
//

import XCTest
@testable import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(bundle, table)
    }
}
