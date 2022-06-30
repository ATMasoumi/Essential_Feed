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
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client:HTTPClient){
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping(Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                completion(FeedItemMapper.map(data, response))
            case .error:
                completion(.failure(.connectivity))
            }
        }
    }
    
}
