//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Balan on 2022-02-17.
//

import EssentialFeed
import Foundation
import XCTest

extension FeedUIIntegrationTests {
    private struct DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        return LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
}
