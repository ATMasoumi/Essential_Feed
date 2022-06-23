//
//  Essential_FeedTests.swift
//  Essential FeedTests
//
//  Created by Amin on 3/27/1401 AP.
//

import XCTest
@testable import Essential_Feed


class RemoteFeedLoader {
    let client: HTTPClient
    init(client:HTTPClient){
        self.client = client
    }
    func load() {
        client.get(from: URL(string: "www.google.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}


class RemoteFeedLoaderTests: XCTestCase {

    func test_init_DoesNotRequestDataFromURL() throws {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        XCTAssertEqual(client.requestedURL,nil)
    }
    
    func test_load_RequestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
    
    class HTTPClientSpy: HTTPClient {
        func get(from url: URL) {
            requestedURL = url
        }
        
        var requestedURL: URL?
        
    }
}

