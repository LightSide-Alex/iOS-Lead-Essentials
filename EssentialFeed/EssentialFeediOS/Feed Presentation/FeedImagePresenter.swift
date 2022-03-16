//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-08.
//
import EssentialFeed

protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    internal init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        display(model: model, image: nil, isLoading: true, shouldRetry: false)
    }
    
    private struct InvalidImageDataError: Error {}
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        display(model: model, image: image, isLoading: false, shouldRetry: false)
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        display(model: model, image: nil, isLoading: false, shouldRetry: true)
    }
    
    private func display(model: FeedImage, image: Image?, isLoading: Bool, shouldRetry: Bool) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: isLoading,
            shouldRetry: shouldRetry
        ))
    }
}
