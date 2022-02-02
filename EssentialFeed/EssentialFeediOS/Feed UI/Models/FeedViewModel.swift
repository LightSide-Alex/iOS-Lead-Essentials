//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-31.
//

import UIKit
import EssentialFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    func load() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
