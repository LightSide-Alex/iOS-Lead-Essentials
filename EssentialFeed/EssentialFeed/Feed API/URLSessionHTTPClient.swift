//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-10-06.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionDataTask
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result(catching: {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            }))
        }
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}
