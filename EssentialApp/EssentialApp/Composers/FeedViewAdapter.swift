//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-23.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)
            
            return view
        })
    }
}
