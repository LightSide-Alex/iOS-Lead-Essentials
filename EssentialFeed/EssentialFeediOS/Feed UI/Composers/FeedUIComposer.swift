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
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDecorator(decoratee: feedLoader))
        
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = presentationAdapter
        feedController.title = FeedPresenter.title
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDecorator(decoratee: imageLoader)),
            loadingView: WeakRefVirtualProxy(feedController))
        
        return feedController
    }
}
