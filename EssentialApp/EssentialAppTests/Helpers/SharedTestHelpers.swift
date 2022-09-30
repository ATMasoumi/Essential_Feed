//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Amin on 7/8/1401 AP.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
