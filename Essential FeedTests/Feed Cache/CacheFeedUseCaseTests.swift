//
//  CacheFeedUseCaseTests.swift
//  Essential FeedTests
//
//  Created by Amin on 5/14/1401 AP.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}
class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
  
    func test_init_doesNotDeleteCacheUponCreation() {
        
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
