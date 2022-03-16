//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-03-16.
//

import Foundation

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
