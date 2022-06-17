//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-03-16.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
