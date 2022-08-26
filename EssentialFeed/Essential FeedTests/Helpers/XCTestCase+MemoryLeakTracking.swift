//
//  XCTestCase+MemoryLeakTracking.swift
//  Essential FeedTests
//
//  Created by Amin on 5/6/1401 AP.
//

import Foundation
import XCTest
extension XCTestCase {
    func trackForMemoryLeaks(_ object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Instance should have beed deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
