//
//  FeedViewController.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/4/1401 AP.
//

import UIKit
import Essential_Feed

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    public override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            self?.refreshControl?.endRefreshing()
        }
    }
}

