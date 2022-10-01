//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Amin on 7/9/1401 AP.
//

import Essential_Feed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
