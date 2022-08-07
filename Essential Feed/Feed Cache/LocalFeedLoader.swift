//
//  LocalFeedLoader.swift
//  Essential Feed
//
//  Created by Amin on 5/16/1401 AP.
//

import Foundation

public class LocalFeedLoader {
    let store: FeedStore
    private let currentDate:  () -> Date
    public init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    public func save(_ items: [FeedItem], completion:@escaping(Error?) -> ()) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cachedDeletionError = error {
                completion(cachedDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    private func cache(_ items: [FeedItem], with completion:@escaping(Error?) -> ()) {
        self.store.insert(items, timestamp: self.currentDate(), completion:  { [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
}
public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

