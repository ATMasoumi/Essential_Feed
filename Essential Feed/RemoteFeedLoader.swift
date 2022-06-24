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
        case invalidData
    }
    
    public init(url: URL, client:HTTPClient){
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping(Error) -> Void) {
        client.get(from: url) { (error, response) in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}

public protocol HTTPClient {
    func get(from url: URL,completion: @escaping(Error?, HTTPURLResponse?) -> Void)
}
