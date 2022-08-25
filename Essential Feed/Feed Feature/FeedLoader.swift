//
//  FeedLoader.swift
//  Essential Feed
//
//  Created by Amin on 3/27/1401 AP.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>
public protocol FeedLoader {
    func load(completion:@escaping(LoadFeedResult) -> ())
}
