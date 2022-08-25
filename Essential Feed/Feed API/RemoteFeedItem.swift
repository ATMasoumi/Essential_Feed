//
//  RemoteFeedItem.swift
//  Essential Feed
//
//  Created by Amin on 5/17/1401 AP.
//

import Foundation

 struct RemoteFeedItem: Decodable {
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
