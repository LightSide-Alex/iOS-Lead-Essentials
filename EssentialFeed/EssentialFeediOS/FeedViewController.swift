//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-01-13.
//

import UIKit
import EssentialFeed

public protocol FeedImageLoader {
    func loadImage(_ url: URL, completion: (Data?) -> Void)
}

public final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var imageLoader: FeedImageLoader?
    private var tableModel = [FeedImage]()
    
    public convenience init(loader: FeedLoader, imageLoader: FeedImageLoader) {
        self.init()
        self.loader = loader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.tableModel = data
                self.tableView.reloadData()
            case .failure(_):
                break
            }
            self.refreshControl?.endRefreshing()
        }
    }
}

extension FeedViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        imageLoader?.loadImage(cellModel.url, completion: { _ in
        })
        return cell
    }
}
