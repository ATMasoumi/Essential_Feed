//
//  FeedViewControllerTests+Localization.swift
//  Essential_FeediOSTests
//
//  Created by Amin on 6/19/1401 AP.
//

import Foundation
import XCTest
import Essential_FeediOS

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
