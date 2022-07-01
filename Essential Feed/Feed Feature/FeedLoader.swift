//
//  FeedLoader.swift
//  Essential Feed
//
//  Created by Amin on 3/27/1401 AP.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion:@escaping(LoadFeedResult) -> ())
}
