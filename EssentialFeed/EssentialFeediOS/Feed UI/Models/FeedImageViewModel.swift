//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-01.
//

import UIKit
import EssentialFeed

final class FeedImageViewModel {
    typealias Observer<T> = (T) -> Void
    
    var hasLocation: Bool { model.location != nil }
    var location: String? { model.location }
    var description: String? { model.description }
    
    var onLoadingStateChange: Observer<Bool>?
    var onImageLoaded: Observer<UIImage>?
    var onLoadingError: Observer<Void>?
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func loadImage() {
        onLoadingStateChange?(true)
        task = imageLoader.loadImageData(from: model.url, completion: { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChange?(false)
            let data = try? result.get()
            if let image = data.flatMap(UIImage.init) {
                self.onImageLoaded?(image)
            } else {
                self.onLoadingError?(())
            }
            
        })
    }
    
    func cancelLoad() {
        task?.cancel()
    }
}
