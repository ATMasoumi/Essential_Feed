//
//  FeedItem.swift
//  Essential Feed
//
//  Created by Amin on 3/27/1401 AP.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
