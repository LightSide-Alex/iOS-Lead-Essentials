//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-08.
//

import EssentialFeed

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    return Data("Any data".utf8)
}

func uniqueImageFeed() -> [FeedImage] {
    return [uniqueImage(), uniqueImage()]
}

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

private struct DummyView: ResourceView {
    func display(_ viewModel: Any) {}
}

var loadError: String {
    return LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}
