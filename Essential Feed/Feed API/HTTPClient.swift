//
//  HTTPClient.swift
//  Essential Feed
//
//  Created by Amin on 4/9/1401 AP.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case error(Error)
}
public protocol HTTPClient {
    func get(from url: URL,completion: @escaping (HTTPClientResult) -> Void)
}
