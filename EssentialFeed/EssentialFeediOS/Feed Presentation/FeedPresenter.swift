//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-07.
//

import EssentialFeed

protocol FeedViewLoader: AnyObject {
    func didChangeLoadingState(_ isLoading: Bool)
}

protocol FeedView {
    func didLoadFeed(_ feed: [FeedImage])
}

final class FeedPresenter {
    var feedView: FeedView?
    weak var loaderView: FeedViewLoader?
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func load() {
        loaderView?.didChangeLoadingState(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.didLoadFeed(feed)
            }
            self?.loaderView?.didChangeLoadingState(false)
        }
    }
}
