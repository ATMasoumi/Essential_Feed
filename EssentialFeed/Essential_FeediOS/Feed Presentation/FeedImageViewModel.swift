//
//  FeedImageViewModel.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/11/1401 AP.
//

import Foundation
import Essential_Feed
import UIKit

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

