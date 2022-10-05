//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Amin on 7/12/1401 AP.
//

import XCTest

class EssentialAppUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displayRemoteFeedWhenCustomerhasConnectivity() {
        
        let app = XCUIApplication()

        app.launch()

        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 22)
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(firstImage.exists)

    }
}
