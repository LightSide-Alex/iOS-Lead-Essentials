//
//  ResourceLoaderPresentationAdapter.swift
//  EssentialApp
//
//  Created by Oleksandr Balan on 2022-06-12.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class ResourceLoaderPresentationAdapter<Resource, View: ResourceView> {
    private var cancellable: AnyCancellable?
    private let loader: () -> AnyPublisher<Resource, Error>
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
            } receiveValue: { [weak self] feed in
                self?.presenter?.didFinishLoading(with: feed)
            }
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}

extension ResourceLoaderPresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }
    
    func didCancelImageRequest() {
        cancel()
    }
}
