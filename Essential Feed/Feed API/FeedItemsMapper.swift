//
//  FeedItemsMapper.swift
//  Essential Feed
//
//  Created by Amin on 4/9/1401 AP.
//

import Foundation

internal class FeedItemMapper {
    private struct Root: Decodable {
        let items: [Item]
        var feed: [FeedItem] {
            items.map({ $0.item })
        }
    }
    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    private static var OK_200: Int { 200 }
    internal static func map(_ data: Data,_ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,let root = try? JSONDecoder().decode(Root.self, from: data) else { return .failure(.invalidData) }
        return .success(root.feed)
        
    }
}

