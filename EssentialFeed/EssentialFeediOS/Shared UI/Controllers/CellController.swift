//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-06-21.
//

import UIKit

public struct CellController {
    public let delegate: UITableViewDelegate?
    public let dataSource: UITableViewDataSource
    public let dataSourcePrefetching: UITableViewDataSourcePrefetching?
    
    public init(dataSource: UITableViewDataSource) {
        self.delegate = nil
        self.dataSource = dataSource
        self.dataSourcePrefetching = nil
    }
    
    public init(_ dataSource: UITableViewDelegate & UITableViewDataSource & UITableViewDataSourcePrefetching) {
        self.delegate = dataSource
        self.dataSource = dataSource
        self.dataSourcePrefetching = dataSource
    }
}
