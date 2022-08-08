//
//  LoadFeedFromCacheUseCaseTests.swift
//  Essential FeedTests
//
//  Created by Amin on 5/17/1401 AP.
//

import XCTest
import Essential_Feed

class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrieveError = anyNSError()
        let exp = expectation(description: "wait for load")
        var expectedError: Error?
        sut.load { error in
            expectedError = error
            exp.fulfill()
        }
        store.completeRetrieval(with: retrieveError)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(expectedError as NSError?, retrieveError)
    }
    // MARK: Helper Methods
   
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
