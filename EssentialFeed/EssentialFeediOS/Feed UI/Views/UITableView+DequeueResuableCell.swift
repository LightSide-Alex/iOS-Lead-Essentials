//
//  UITableView+DequeueResuableCell.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-02-16.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
