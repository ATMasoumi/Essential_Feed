//
//  FeedRefreshViewController.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/10/1401 AP.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
  
    @IBOutlet private var view: UIRefreshControl?
        
    var delegate: FeedRefreshViewControllerDelegate?
    
        
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
        
    }
}
