//
//  CodableFeedStoreTests.swift
//  Essential FeedTests
//
//  Created by Amin on 5/21/1401 AP.
//

import XCTest
import Essential_Feed

class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [LocalFeedImage]
        let timestamp: Date
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
           return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        
        completion(.found(feed: cache.feed, timestamp: cache.timestamp))
        
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion){
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(Cache(feed: feed, timestamp: timestamp))
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}
class CodableFeedStoreTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func setUp() {
        super.setUp()
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "wait on retrieve")
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty cache, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
    }
    
    func test_retrieve_hasNoSideEffectOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "wait on retrieve")
        sut.retrieve { firstResult in
            sut.retrieve { secondReesult in
                switch (firstResult, secondReesult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same result, got \(firstResult) and  \(secondReesult) instead")
                }
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1)
        
    }
    
    func test_retrieveAfterInsertingToEmptyCahce_deliversInsertedValues() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "wait on retrieve")
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError)
            sut.retrieve { retrieveReesult in
                switch retrieveReesult {
                case let .found(retrievedFeed,retrievedTimestamp ):
                    XCTAssertEqual(retrievedFeed, feed)
                    XCTAssertEqual(retrievedTimestamp, timestamp)
                    break
                default:
                    XCTFail("expected found result with feed \(feed) and timestamp \(timestamp), got \(retrieveReesult) instead")
                }
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1)
        
    }
    
}
