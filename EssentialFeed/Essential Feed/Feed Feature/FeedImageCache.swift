//
//  FeedImageCache.swift
//  Essential Feed
//
//  Created by Amin on 7/9/1401 AP.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
