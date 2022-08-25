//
//  FeedStore.swift
//  Essential Feed
//
//  Created by Amin on 5/16/1401 AP.
//

import Foundation


public struct CachedFeed {
    public let feed: [LocalFeedImage]
    public let timestamp: Date
    
    public init(feed: [LocalFeedImage], timestamp: Date) {
        self.feed = feed
        self.timestamp = timestamp
    }
}

public protocol FeedStore {
    
    typealias DeletionError = Error?
    typealias DeletionCompletion = (DeletionError) -> Void
    
    typealias InsertionError = Error?
    typealias InsertionCompletion = (InsertionError) -> Void
    
    typealias RetreivalResult = Result<CachedFeed?, Error>

    typealias RetrievalCompletion = (RetreivalResult) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
