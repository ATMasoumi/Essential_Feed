//
//  FeedStore.swift
//  Essential Feed
//
//  Created by Amin on 5/16/1401 AP.
//

import Foundation

public enum RetreiveCachedFeedResult{
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}
public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetreiveCachedFeedResult) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
