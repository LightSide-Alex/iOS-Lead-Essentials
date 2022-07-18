//
//  Feed Presenter.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-17.
//

import Foundation

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Title for the feed view")
    }
}
