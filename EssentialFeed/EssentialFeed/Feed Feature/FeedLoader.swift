//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Joel Bell on 9/7/21.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (Result<[FeedItem], Error>) -> Void)
}