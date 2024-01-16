//  Constants.swift

import Foundation
import SwiftUI

enum PublicationStatus: Int16, CaseIterable, Identifiable {
    case ongoing = 0 // 連載中
    case completed = 1 // 完結済
    case incomplete = 2 // 未完

    var id: Int16 { self.rawValue }

    var description: String {
        switch self {
        case .ongoing:
            return "連載中"
        case .completed:
            return "完結済"
        case .incomplete:
            return "未完結"
        }
    }
}

enum ActiveSheet: Identifiable {
    case sort, filter
    
    var id: Int {
        hashValue
    }
}

enum SortOption {
    case defaultOrder, titleAscending, titleDescending, volumeAscending, volumeDescending
}

enum FilterOption {
    case all, ongoing, completed, incomplete
}

// 円グラフのスライスデータを表す構造体
struct PieSliceData {
    var value: Double
    var label: String
    var color: Color
}
