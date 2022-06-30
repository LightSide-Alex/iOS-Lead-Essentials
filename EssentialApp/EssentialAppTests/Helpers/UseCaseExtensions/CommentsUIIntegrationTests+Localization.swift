//
//  CommentsUIIntegrationTests+Localization.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-06-28.
//

import EssentialFeed
import Foundation
import XCTest

extension CommentsUIIntegrationTests {
    private struct DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        return LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
}
