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
    public typealias SaveResult = Error?
    public init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    public func save(_ feed: [FeedImage], completion:@escaping(SaveResult) -> ()) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cachedDeletionError = error {
                completion(cachedDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load() {
        store.retrieve()
    }
    private func cache(_ feed: [FeedImage], with completion:@escaping(SaveResult) -> ()) {
        self.store.insert(feed.toLocal(), timestamp: self.currentDate(), completion:  { [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
}

extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}
