//
//  UIButton+TestHelpers.swift
//  Essential_FeediOSTests
//
//  Created by Amin on 6/20/1401 AP.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
