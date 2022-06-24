//
//  Essential_FeedTests.swift
//  Essential FeedTests
//
//  Created by Amin on 3/27/1401 AP.
//

import XCTest
import Essential_Feed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_DoesNotRequestDataFromURL() throws {

        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_loadTwice_RequestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs,[url, url])
    }
    
    func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return(sut, client)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        let clientError = NSError(domain: "Test", code: 0)
        client.completion(with: clientError)
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion:(Error) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url,completion))
        }
        func completion(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
    }
}

