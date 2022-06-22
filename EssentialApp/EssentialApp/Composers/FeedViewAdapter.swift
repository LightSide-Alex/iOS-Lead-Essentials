//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(controller: ListViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = ResourceLoaderPresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>> { [imageLoader] in
                imageLoader(model.url)
            }
            
            let view = FeedImageCellController(viewModel: FeedImagePresenter.map(model), delegate: adapter)
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: UIImage.tryMake)
            
            return CellController(id: UUID(), dataSource: view)
        })
    }
}

extension UIImage {
    struct InvalidImageData: Error {}

    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return image
    }
}
