//
//  UIRefreshControl+TestHelpers.swift
//  Essential_FeediOSTests
//
//  Created by Amin on 6/20/1401 AP.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach({ target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {(target as NSObject).perform(Selector($0))
            }
        })
    }
}
