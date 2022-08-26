//
//  FeedViewControllerTests.swift
//  Essential_FeediOSTests
//
//  Created by Amin on 6/4/1401 AP.
//

import XCTest
import Essential_Feed

final class FeedViewController: UIViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    override func viewDidLoad() {
        loader?.load { result in
            
        }
    }
}
class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
         let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    // MARK: Helpers
    
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCount = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> ()) {
            loadCallCount += 1
        }
        
        
    }
}
