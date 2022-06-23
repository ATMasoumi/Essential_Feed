//
//  RemoteFeedLoade.swift
//  Essential Feed
//
//  Created by Amin on 4/2/1401 AP.
//

import Foundation

public final class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    public init(url: URL, client:HTTPClient){
        self.client = client
        self.url = url
    }
    public func load() {
        client.get(from: url)
    }
}

public protocol HTTPClient {
    func get(from url: URL)
}
