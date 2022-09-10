//
//  FeedViewControllerTests+LoaderSpy.swift
//  Essential_FeediOSTests
//
//  Created by Amin on 6/19/1401 AP.
//

import Foundation
import Essential_FeediOS
import Essential_Feed

extension FeedViewControllerTests {
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        // MARK: FeedLoader
        private var feedRequests = [(FeedLoader.Result) -> Void]()
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            feedRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }
        
        // MARK: FeedImageDataLoader
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallBack: () -> Void
            func cancel() {
                cancelCallBack()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            imageRequests.map { $0.url }
        }
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void)-> FeedImageDataLoaderTask {
            imageRequests.append((url,completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url)}
        }
        
        func cancelImageDataLoad(from url: URL) {
            cancelledImageURLs.append(url)
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0){
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an Error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}
