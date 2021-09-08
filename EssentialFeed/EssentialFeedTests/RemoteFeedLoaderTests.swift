//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Joel Bell on 9/7/21.
//

import EssentialFeed
import XCTest

class RemoteFeedLoaderTests: XCTestCase {
    
    // MARK: - Nested Type
    
    class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        var completions: [(Error) -> Void] = []
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
        }
    }
    
    // MARK: - Tests

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url: URL = .init(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url: URL = .init(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors: [RemoteFeedLoader.Error] = []
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }

    // MARK: - Helper
    
    private func makeSUT(url: URL = .init(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client: HTTPClientSpy = .init()
        let loader: RemoteFeedLoader = .init(url: url, client: client)
        return (loader, client)
    }
}
