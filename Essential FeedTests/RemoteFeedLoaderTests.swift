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
        sut.load()
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_loadTwice_RequestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs,[url, url])
    }
    
    func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return(sut, client)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURLs:[URL] = []
        var error: Error?
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}

