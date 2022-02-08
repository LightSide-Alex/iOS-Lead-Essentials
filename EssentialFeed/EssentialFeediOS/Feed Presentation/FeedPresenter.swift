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

protocol FeedPresentationLogic {
    func didStartLoading()
    func didFinishLoadingFeed(with feed: [FeedImage])
    func didFinishLoadingFeed(with error: Error)
}

final class FeedPresenter: FeedPresentationLogic {
    private let feedView: FeedView
    private let loaderView: FeedViewLoader
    
    init(feedView: FeedView, loaderView: FeedViewLoader) {
        self.feedView = feedView
        self.loaderView = loaderView
    }
    
    func didStartLoading() {
        loaderView.didChangeLoadingState(.init(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.didLoadFeed(.init(feed: feed))
        loaderView.didChangeLoadingState(.init(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loaderView.didChangeLoadingState(.init(isLoading: false))
    }
}
