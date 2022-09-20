//
//  FeedItem.swift
//  Essential Feed
//
//  Created by Amin on 3/27/1401 AP.
//

import Foundation

public struct FeedImage: Hashable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL){
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
