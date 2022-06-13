//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-18.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
