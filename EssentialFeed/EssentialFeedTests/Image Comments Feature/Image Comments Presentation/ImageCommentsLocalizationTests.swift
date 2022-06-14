//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-06-14.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

}
