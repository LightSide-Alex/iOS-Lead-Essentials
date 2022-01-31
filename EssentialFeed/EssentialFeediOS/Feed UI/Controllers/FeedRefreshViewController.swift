//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-27.
//
import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    @objc func refresh() {
        viewModel.load()
    }
    
    func binded(_ refreshControl: UIRefreshControl) -> UIRefreshControl {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        viewModel.onLoadingStateChange = { [weak refreshControl] isLoading in
            if isLoading {
                refreshControl?.beginRefreshing()
            } else {
                refreshControl?.endRefreshing()
            }
        }
        return refreshControl
    }
}
