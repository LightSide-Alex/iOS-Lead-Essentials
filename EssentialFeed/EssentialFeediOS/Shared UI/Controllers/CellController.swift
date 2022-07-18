//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-06-21.
//

import UIKit

public struct CellController {
    public let id: AnyHashable
    public let delegate: UITableViewDelegate?
    public let dataSource: UITableViewDataSource
    public let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    
    public init(id: AnyHashable, dataSource: UITableViewDataSource) {
        self.id = id
        
        self.dataSource = dataSource
        self.delegate = dataSource as? UITableViewDelegate
        self.dataSourcePrefetching = dataSource as? UITableViewDataSourcePrefetching
    }
}

extension CellController: Hashable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
