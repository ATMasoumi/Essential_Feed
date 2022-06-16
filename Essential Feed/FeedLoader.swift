//
//  FeedLoader.swift
//  Essential Feed
//
//  Created by Amin on 3/27/1401 AP.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}
protocol FeedLoader {
    func load(completion:@escaping(LoadFeedResult) -> ())
}
