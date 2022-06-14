//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-06-09.
//

import XCTest
@testable import EssentialFeed

final class SharedLocalizationTests: XCTestCase {
    private struct DummyResourceView: ResourceView {
        typealias ResourceViewModel = String
        func display(_ viewModel: ResourceViewModel) {}
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<String, DummyResourceView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
