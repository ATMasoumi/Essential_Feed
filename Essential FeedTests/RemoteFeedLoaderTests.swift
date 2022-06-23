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
        XCTAssertEqual(client.requestedURL,nil)
    }
    
    func test_load_RequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
    
    func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return(sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        func get(from url: URL) {
            requestedURL = url
        }
    }
}

