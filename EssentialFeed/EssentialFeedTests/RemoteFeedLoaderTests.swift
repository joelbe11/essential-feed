//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Joel Bell on 9/7/21.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteFeedLoaderTests: XCTestCase {
    
    class HTTPClientSpy: HTTPClient {
        var requestURL: URL?
        
        func get(from url: URL) {
            requestURL = url
        }
    }

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertNil(client.requestURL)
    }
    
    func test_load_requestDataFromURL() {
        let url: URL = .init(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(url, client.requestURL)
    }

    // MARK: - Helper
    
    private func makeSUT(url: URL = .init(string: "http://google.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client: HTTPClientSpy = .init()
        let loader: RemoteFeedLoader = .init(url: url, client: client)
        return (loader, client)
    }
}
