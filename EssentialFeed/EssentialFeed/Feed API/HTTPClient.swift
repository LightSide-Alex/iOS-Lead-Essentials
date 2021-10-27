//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-12.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func getFrom(url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
