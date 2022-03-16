//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-03-16.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
