//
//  CacheFeedUseCaseTests.swift
//  Essential FeedTests
//
//  Created by Amin on 5/14/1401 AP.
//

import XCTest
import Essential_Feed

class LocalFeedLoader {
    let store: FeedStore
    private let currentDate:  () -> Date
    init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    func save(_ items: [FeedItem], completion:@escaping(Error?) -> ()) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cachedDeletionError = error {
                completion(cachedDeletionError)
            } else {
                self.store.insert(items, timestamp: self.currentDate(), completion:  { [weak self] error in
                    guard self != nil else { return }
                    completion(error)
                })
            }
        }
    }
    
}
protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}


class CacheFeedUseCaseTests: XCTestCase {
  
    func test_init_doesNotDeleteCacheUponCreation() {
        
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        sut.save(items){ _ in}
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeedMessage])
    }
    
    func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        let deletionError = anyNSError()
        
        sut.save(items){ _ in}
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeedMessage])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut,store) = makeSUT(currentDate: { timestamp })
        let items = [uniqueItem(),uniqueItem()]
        
        sut.save(items){ _ in}
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeedMessage, .insert(items, timestamp)])

        
    }
    
    func test_save_failsOnDeletionError() {
        let (sut,store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWith: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut,store) = makeSUT()
        let insertionError = anyNSError()
        expect(sut, toCompleteWith: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut,store) = makeSUT()
        expect(sut, toCompleteWith: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })

    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDealocated() {
        let store = FeedStoreSpy()
        var sut : LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [Error?]()
        sut?.save([uniqueItem()], completion: { receivedResults.append($0) })
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDealocated() {
        let store = FeedStoreSpy()
        var sut : LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [Error?]()
        sut?.save([uniqueItem()], completion: { receivedResults.append($0) })
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: Helper Methods
   
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store,currentDate: currentDate)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for save completion")
        var recievedError: Error?
        sut.save([uniqueItem()]) { error in
            recievedError = error
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(recievedError as NSError?, expectedError, file: file, line: line)
    }
    private class FeedStoreSpy: FeedStore {
        typealias DeletionCompletion = (Error?) -> Void
        typealias InsertionCompletion = (Error?) -> Void
        
        enum ReceivedMessage: Equatable {
            case deleteCachedFeedMessage
            case insert([FeedItem], Date)
        }
        
        private(set) var receivedMessages = [ReceivedMessage]()
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()

        
        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCachedFeedMessage)
        }
        
        func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(items, timestamp))
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
    }
    
    private func uniqueItem() -> FeedItem {
        FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
