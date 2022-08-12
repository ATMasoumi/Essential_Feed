//
//  FeedCacheTestHelper.swift
//  Essential FeedTests
//
//  Created by Amin on 5/20/1401 AP.
//

import Foundation
import Essential_Feed

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(),uniqueImage()]
    let localFeedItems = items.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    return (items, localFeedItems)
}

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    private var feedCacheMaxAgeInDays: Int{
        return 7
    }
    
    private func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
extension Date {
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}
