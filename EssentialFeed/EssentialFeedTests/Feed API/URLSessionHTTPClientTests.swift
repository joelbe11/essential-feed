//
//  URLHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Joel Bell on 9/15/21.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    private class URLSessionSpy: URLSession {
        var receivedURLs: [URL] = []
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeSessionDataTask()
        }
    }
    
    private class FakeSessionDataTask: URLSessionDataTask { }
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
}
