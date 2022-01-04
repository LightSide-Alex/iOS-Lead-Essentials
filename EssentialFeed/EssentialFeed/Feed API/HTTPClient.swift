//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-09-12.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func getFrom(url: URL, completion: @escaping (Result) -> Void)
}
