//
//  FeedRefreshViewController.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/10/1401 AP.
//

import UIKit
import Essential_Feed

final class FeedRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
       let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onRefresh: (([FeedImage]) -> Void)?
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
