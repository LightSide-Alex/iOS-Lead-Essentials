//
//  RemoteLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-06-01.
//

import Foundation

public final class RemoteLoader<Resource> {
    public typealias Result = Swift.Result<Resource, Swift.Error>
    
    private let url: URL
    private let client: HTTPClient
    private let mapper: (Data, HTTPURLResponse) throws -> Resource
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient, mapper: @escaping (Data, HTTPURLResponse) throws -> Resource) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let items = try mapper(data, response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
