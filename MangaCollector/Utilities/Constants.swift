//  Constants.swift

import Foundation
import SwiftUI

enum PublicationStatus: Int16, CaseIterable, Identifiable {
    case ongoing = 0
    case completed = 1
    case incomplete = 2

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

extension PublicationStatus {
    var color: Color {
        switch self {
        case .ongoing:
            return .green
        case .completed:
            return .blue
        case .incomplete:
            return .red
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
    case all, ongoing, completed, incomplete, favorites
}

enum DisplayMode {
    case list
    case icons
}

enum AlertType: Identifiable {
    case saveSuccess
    case saveFailure
    case duplicateVolume
    case titleError
    case authorNameError
    
    var id: Int {
        hashValue
    }
}


enum GraphTab {
    case publicationStatus, publisher
}

// 円グラフのスライスデータを表す構造体
struct PieSliceData {
    var value: Double
    var label: String
    var color: Color
}

let publishers = ["選択なし","集英社（Shueisha）", "講談社（Kodansha）", "小学館（Shogakukan）", "秋田書店（Akita Shoten）", "角川書店（Kadokawa Shoten）", "白泉社（Hakusensha）", "双葉社（Futabasha）", "一迅社（Ichijinsha）", "芳文社（Houbunsha）", "スクウェア・エニックス（Square Enix）", "新潮社（Shinchosha）", "徳間書店（Tokuma Shoten）", "リブレ出版（Libre Publishing）", "幻冬舎コミックス（Gentosha Comics）", "大洋図書（Taiyo Tosho）", "マッグガーデン（Mag Garden）", "エンターブレイン（Enterbrain）", "芸文社（Geibunsha）", "コアミックス（Coremix）", "リイド社（Leed Publishing）", "ぶんか社（Bunkasha）", "宙出版（Ohzora Publishing）", "竹書房（Takeshobo）", "ビブロス（Biblos）", "イースト・プレス（East Press）","その他"]

let graphHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 400 : 250
