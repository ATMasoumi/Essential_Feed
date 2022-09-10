//
//  UIControl+TestHelpers.swift
//  Essential_FeediOSTests
//
//  Created by Amin on 6/20/1401 AP.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
