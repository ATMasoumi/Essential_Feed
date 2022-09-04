//
//  FeedRefreshViewController.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/10/1401 AP.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
  
    private(set) lazy var view: UIRefreshControl = loadView(UIRefreshControl())
        
    private let loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
        
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
        
    }
    
    private func loadView(_ view: UIRefreshControl) -> UIRefreshControl{
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
