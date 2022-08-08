//
//  RemoteFeedItem.swift
//  Essential Feed
//
//  Created by Amin on 5/17/1401 AP.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
