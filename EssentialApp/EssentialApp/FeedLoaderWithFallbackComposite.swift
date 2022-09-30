//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Amin on 7/8/1401 AP.
//

import Essential_Feed

public class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primary: FeedLoader
    private let fallback: FeedLoader
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    public func load(completion: @escaping (FeedLoader.Result) -> ()) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
