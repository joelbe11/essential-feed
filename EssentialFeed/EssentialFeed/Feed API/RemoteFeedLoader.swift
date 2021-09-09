//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Joel Bell on 9/7/21.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    
    // MARK: - Nested Types
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    // MARK: - Private Properties
    
    private let url: URL
    private let client: HTTPClient
    
    // MARK: - Lifecycle
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    // MARK: - Public Functions
        
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        }
    }
}
