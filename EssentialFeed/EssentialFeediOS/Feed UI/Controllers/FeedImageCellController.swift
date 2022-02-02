//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-27.
//

import UIKit

final class FeedImageCellController {
    private let viewModel: FeedImageViewModel
    
    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        
        viewModel.onLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.feedImageContainer.startShimmering()
            } else {
                cell?.feedImageContainer.stopShimmering()
            }
        }
        viewModel.onImageLoaded = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        viewModel.onLoadingError = { [weak cell] _ in
            cell?.feedImageRetryButton.isHidden = false
        }
        
        cell.onRetry = viewModel.loadImage
        viewModel.loadImage()
        
        return cell
    }
    
    func preload() {
        viewModel.loadImage()
    }
    
    func cancelLoad() {
        viewModel.cancelLoad()
    }
}
