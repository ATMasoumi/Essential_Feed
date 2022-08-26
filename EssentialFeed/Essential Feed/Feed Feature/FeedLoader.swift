//
//  FeedLoader.swift
//  Essential Feed
//
//  Created by Amin on 3/27/1401 AP.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion:@escaping(Result) -> ())
}
