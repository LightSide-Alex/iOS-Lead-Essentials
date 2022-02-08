//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-27.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presenter = FeedPresenter()
        let presentationAdapter = FeedLoaderPresentationAdapter(presenter: presenter, feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(loadFeed: presentationAdapter.loadFeed)
        let feedController = FeedViewController(refreshController: refreshController)
        let weakFeedViewLoader = WeakRefVirtualProxy(object: refreshController)
        presenter.feedView = FeedViewAdapter(controller: feedController, loader: imageLoader)
        presenter.loaderView = weakFeedViewLoader
        
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    weak var object: T?
    
    init(object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedViewLoader where T: FeedViewLoader {
    func didChangeLoadingState(_ viewModel: FeedLoadingViewModel) {
        object?.didChangeLoadingState(viewModel)
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader
    
    init(controller: FeedViewController, loader: FeedImageDataLoader) {
        self.controller = controller
        self.loader = loader
    }
    
    func didLoadFeed(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
        }
    }
}

private final class FeedLoaderPresentationAdapter {
    private let presenter: FeedPresentationLogic
    private let feedLoader: FeedLoader
    
    init(presenter: FeedPresentationLogic, feedLoader: FeedLoader) {
        self.presenter = presenter
        self.feedLoader = feedLoader
    }
    
    func loadFeed() {
        presenter.didStartLoading()
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter.didFinishLoadingFeed(with: error)
            }
        }
    }
}
