//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-27.
//
import UIKit

final class FeedRefreshViewController: NSObject {
    private var loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    @objc func refresh() {
        loadFeed()
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
