//
//  SortOption.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case viral = "viral"
    case top = "top"
    case time = "time"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .viral: return "Viral"
        case .top: return "Top"
        case .time: return "Time"
        }
    }
}

enum DateRange: String, CaseIterable, Identifiable {
    case allTime = "all"
    case week = "week"
    case month = "month"
    case year = "year"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .allTime: return "All Time"
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
}

