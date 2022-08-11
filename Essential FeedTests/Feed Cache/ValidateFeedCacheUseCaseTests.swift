//
//  ValidateFeedCacheUseCaseTests.swift
//  Essential FeedTests
//
//  Created by Amin on 5/20/1401 AP.
//

import XCTest
import Essential_Feed

class ValidateFeedCacheUseCaseTests: XCTestCase {

    
    func test_init_doesNotDeleteCacheUponCreation() {
        
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    func test_load_deletesCacheOnRetrievalError() {
        let (sut , store) = makeSUT()
        let retrievalError = anyNSError()
        
        sut.validateCache()
        store.completeRetrieval(with: retrievalError)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeedMessage])


    }
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
      
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteLessThanSevenDaysOldCache() {
      
        let feed = uniqueImageFeed()
        let (sut, store) = makeSUT()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        
        sut.validateCache() 
        
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimeStamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesOnSevenDaysOldCache() {
      
        let feed = uniqueImageFeed()
        let (sut, store) = makeSUT()
        let fixedCurrentDate = Date()
        let sevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7)
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimeStamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCachedFeedMessage])
    }
    
    func test_validateCache_deletesOnMoreThanSevenDaysOldCache() {
      
        let feed = uniqueImageFeed()
        let (sut, store) = makeSUT()
        let fixedCurrentDate = Date()
        let moreThanSevenDaysOldTimeStamp = fixedCurrentDate.adding(days: -7).adding(days: -1)
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimeStamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCachedFeedMessage])
    }
    
    // MARK: helper methods
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store,currentDate: currentDate)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        
        return (sut, store)
    }
}
