//
//  FeedCache.swift
//  Essential_FeedAPIEndToEndTests
//
//  Created by Amin on 7/9/1401 AP.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
