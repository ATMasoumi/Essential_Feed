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
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store,currentDate: currentDate)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        
        return (sut, store)
    }
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
