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
        store.deleteCachedFeed { [unowned self] error in
            
            if error == nil {
                store.insert(items, timestamp: currentDate(), completion: completion)
            } else {
                completion(error)
            }
        }
    }
    
}
class FeedStore {
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
        let items = [uniqueItem(),uniqueItem()]
        let deletionError = anyNSError()
        let exp = expectation(description: "wait for save completion")
        var recievedError: Error?
        sut.save(items) { error in
            recievedError = error
            exp.fulfill()
        }
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(recievedError as NSError?, deletionError)
    }
    
    func test_save_failsOnInsertionError() {
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        let insertionError = anyNSError()
        let exp = expectation(description: "wait for save completion")
        var recievedError: Error?
        sut.save(items) { error in
            recievedError = error
            exp.fulfill()
        }
        store.completeDeletionSuccessfully()
        store.completeInsertion(with: insertionError)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(recievedError as NSError?, insertionError)
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        let exp = expectation(description: "wait for save completion")
        var recievedError: Error?
        sut.save(items) { error in
            recievedError = error
            exp.fulfill()
        }
        store.completeDeletionSuccessfully()
        store.completeInsertionSuccessfully()
        wait(for: [exp], timeout: 1)
        XCTAssertNil(recievedError)
    }
    // MARK: Helper Methods
   
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store,currentDate: currentDate)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        
        return (sut, store)
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
