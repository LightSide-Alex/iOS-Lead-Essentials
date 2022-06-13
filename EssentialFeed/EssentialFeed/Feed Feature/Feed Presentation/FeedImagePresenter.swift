//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-18.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ model: FeedImage) -> FeedImageViewModel {
        return FeedImageViewModel(
            description: model.description,
            location: model.location
        )
    }
}
