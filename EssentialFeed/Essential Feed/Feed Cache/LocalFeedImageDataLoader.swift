//
//  LocalFeedImageDataLoader.swift
//  Essential Feed
//
//  Created by Amin on 7/3/1401 AP.
//

import Foundation

public final class LocalFeedImageDataLoader {
   
    private let store: FeedImageDataStore

   
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}
extension LocalFeedImageDataLoader {
    public typealias SaveResult = Result<Void, Swift.Error>

    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { _ in }
    }
    
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    public typealias LoadResult = FeedImageDataLoader.Result

    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    private final class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: (result
                                    .mapError({ _ in LoadError.failed})
                                    .flatMap({ data in data.map { .success($0) } ?? .failure(LoadError.notFound) })
                        ))
        }
        return task
    }
}