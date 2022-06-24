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
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client:HTTPClient){
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping(Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}

public protocol HTTPClient {
    func get(from url: URL,completion: @escaping(Error) -> Void)
}
