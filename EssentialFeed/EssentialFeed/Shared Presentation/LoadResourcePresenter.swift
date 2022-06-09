//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-06-09.
//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: FeedViewModel)
}

public protocol ResourceErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public protocol ResourceLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public final class LoadResourcePresenter {
    private let resourceView: ResourceView
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    
    public init(resourceView: ResourceView, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
        errorView.display(.noError)
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        resourceView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: error.localizedDescription))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
