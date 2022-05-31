//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2022-03-17.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
