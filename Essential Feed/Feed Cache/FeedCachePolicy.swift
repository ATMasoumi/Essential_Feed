//
//  FeedCachePolicy.swift
//  Essential FeedTests
//
//  Created by Amin on 5/20/1401 AP.
//

import Foundation

 final class FeedCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    private static var maxCacheInDays: Int {
        7
    }
     static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
