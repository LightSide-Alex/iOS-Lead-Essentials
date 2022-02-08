//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-27.
//
import UIKit

protocol FeedRefreshViewControllerDelegate {
    func loadFeed()
}

final class FeedRefreshViewController: NSObject {
    private let delegate: FeedRefreshViewControllerDelegate
    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    @objc func refresh() {
        delegate.loadFeed()
    }
}

extension FeedRefreshViewController: FeedViewLoader {
    func didChangeLoadingState(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}
