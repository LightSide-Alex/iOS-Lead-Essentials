//
//  RemoteLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2022-06-01.
//

import XCTest
@testable import EssentialFeed

class RemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://custom-url.com")!
        let (sut, client) = makeSUT(with: url)
        sut.load { _ in }
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://custom-url.com")!
        let (sut, client) = makeSUT(with: url)
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        expect(sut, completeWith: failure(.connectivity)) {
            client.complete(with: NSError(domain: "test", code: 0, userInfo: nil))
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        expect(sut, completeWith: .success([])) {
            client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithNonEmptyJSONList() {
        let (sut, client) = makeSUT()
        let (item1, jsonItem1) = makeFeedItem()
        let (item2, jsonItem2) = makeFeedItem(description: "Description", location: "Location")
        let (item3, jsonItem3) = makeFeedItem(description: "The whole new description")
        
        expect(sut, completeWith: .success([item1, item2, item3])) {
            let json = makeItemsJSON([jsonItem1, jsonItem2, jsonItem3])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTIsDeallocated() {
        let client = HTTPClientSpy()
        let url = URL(string: "http://custom-url.com")!
        var sut: RemoteLoader? = RemoteLoader(url: url, client: client)
        
        var results: [RemoteLoader.Result] = []
        sut?.load { results.append($0) }
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(results.isEmpty)
    }
    
    private func expect(_ sut: RemoteLoader,
                        completeWith expectedResult: RemoteLoader.Result,
                        for action: () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for load to complete")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteLoader.Error), .failure(expectedError as RemoteLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(with url: URL = URL(string: "http://custom-url.com")!,
                         file: StaticString = #file,
                         line: UInt = #line) -> (RemoteLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(url: url, client: client)
        trackForMemoryLeaks(for: client, file: file, line: line)
        trackForMemoryLeaks(for: sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func makeFeedItem(id: UUID = UUID(),
                              description: String? = nil,
                              location: String? = nil,
                              image: URL = URL(string: "http://custom-url.com")!) -> (FeedImage, [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: image)
        let jsonItem: [String: Any] = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ].compactMapValues { $0 }
        
        return (item, jsonItem)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let dict =  ["items": items]
        return try! JSONSerialization.data(withJSONObject: dict)
    }
    
    private func failure(_ error: RemoteLoader.Error) -> RemoteLoader.Result {
        return .failure(error)
    }
}
