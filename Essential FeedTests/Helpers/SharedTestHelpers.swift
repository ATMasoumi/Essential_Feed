//
//  SharedTestHelpers.swift
//  Essential FeedTests
//
//  Created by Amin on 5/20/1401 AP.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
