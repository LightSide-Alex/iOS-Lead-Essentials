//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-07.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}
protocol FeedViewLoader {
    func didChangeLoadingState(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}
protocol FeedView {
    func didLoadFeed(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    var feedView: FeedView?
    var loaderView: FeedViewLoader?
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func load() {
        loaderView?.didChangeLoadingState(.init(isLoading: true))
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.didLoadFeed(.init(feed: feed))
            }
            self?.loaderView?.didChangeLoadingState(.init(isLoading: false))
        }
    }
}
