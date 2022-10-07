//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Amin on 7/15/1401 AP.
//

import XCTest
import Essential_FeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {

    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertTrue(topController is FeedViewController,"Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected feed controller as top view controller, got \(String(describing: topController)) instead")
    }

}
