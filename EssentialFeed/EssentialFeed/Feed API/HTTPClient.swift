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
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func getFrom(url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
