//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Balan on 2021-09-01.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
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
        expect(sut, completeWith: .failure(.connectivity)) {
            client.complete(with: NSError(domain: "test", code: 0, userInfo: nil))
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 300, 400, 500].enumerated().forEach { index, code in
            expect(sut, completeWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, data: makeItemsJSON([]), at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        let json = "Invalid JSON".utf8
        expect(sut, completeWith: .failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: Data(json))
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
    
    private func expect(_ sut: RemoteFeedLoader,
                        completeWith result: RemoteFeedLoader.Result,
                        for action: () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        var results: [RemoteFeedLoader.Result] = []
        sut.load { results.append($0) }
        
        action()
        XCTAssertEqual(results, [result], file: file, line: line)
    }
    
    private func makeSUT(with url: URL = URL(string: "http://custom-url.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func makeFeedItem(id: UUID = UUID(),
                              description: String? = nil,
                              location: String? = nil,
                              image: URL = URL(string: "http://custom-url.com")!) -> (FeedItem, [String: Any]) {
        let item = FeedItem(id: id, description: description, location: location, image: image)
        let jsonItem: [String: Any] = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "imageURL": item.image.absoluteString
        ].compactMapValues { $0 }
        
        return (item, jsonItem)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let dict =  ["items": items]
        return try! JSONSerialization.data(withJSONObject: dict)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestURLs: [URL] {
            messages.map { $0.url }
        }
        
        private var messages: [(url: URL, completion: (HTTPClientResult) -> Void)] = []
        
        func getFrom(url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.error(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
    
}
