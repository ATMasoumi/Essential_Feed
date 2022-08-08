//
//  FeedItemsMapper.swift
//  Essential Feed
//
//  Created by Amin on 4/9/1401 AP.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}

internal class FeedItemMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    private static var OK_200: Int { 200 }
    internal static func map(_ data: Data,_ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,let root = try? JSONDecoder().decode(Root.self, from: data) else { throw RemoteFeedLoader.Error.invalidData }
        return root.items
        
    }
}

