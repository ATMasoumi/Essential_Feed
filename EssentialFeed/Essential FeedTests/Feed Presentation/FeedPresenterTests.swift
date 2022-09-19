//
//  FeedPresenterTests.swift
//  Essential FeedTests
//
//  Created by Amin on 6/28/1401 AP.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}
class FeedPresenterTests: XCTestCase {

    func test_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expect no view messages")
    }
    
    // MARK: Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
