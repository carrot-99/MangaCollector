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

enum SortOption: String, CaseIterable, Identifiable {
    case defaultOrder, titleAscending, titleDescending, volumeAscending, volumeDescending

    var id: String { rawValue }

    var description: String {
        switch self {
        case .defaultOrder:
            return "登録順"
        case .titleAscending:
            return "タイトル昇順"
        case .titleDescending:
            return "タイトル降順"
        case .volumeAscending:
            return "巻数昇順"
        case .volumeDescending:
            return "巻数降順"
        }
    }
}

enum FilterOption: String, CaseIterable, Identifiable {
    case all, favorites, ongoing, completed, incomplete, hasMissingVolumes

    var id: String { rawValue }

    var description: String {
        switch self {
        case .all:
            return "全作品"
        case .favorites:
            return "お気に入り"
        case .ongoing:
            return "連載中"
        case .completed:
            return "完結済"
        case .incomplete:
            return "未完結"
        case .hasMissingVolumes:
            return "不足巻あり"
        }
    }

    func matches(_ manga: Manga) -> Bool {
        switch self {
        case .all:
            return true
        case .favorites:
            return manga.favorite
        case .ongoing:
            return manga.status == .ongoing
        case .completed:
            return manga.status == .completed
        case .incomplete:
            return manga.status == .incomplete
        case .hasMissingVolumes:
            return !manga.missingVolumeNumbers.isEmpty
        }
    }
}

enum DisplayMode: String, CaseIterable, Identifiable {
    case list
    case icons

    var id: String { rawValue }

    var description: String {
        switch self {
        case .list:
            return "リスト表示"
        case .icons:
            return "アイコン表示"
        }
    }

    var systemImage: String {
        switch self {
        case .list:
            return "list.bullet"
        case .icons:
            return "square.grid.3x2"
        }
    }
}

enum AlertType: Identifiable {
    case saveSuccess
    case saveFailure
    case titleError

    var id: Int {
        hashValue
    }
}

enum GraphTab {
    case publicationStatus, publisher
}

enum UserDefaultsKey {
    static let hasAgreedToTerms = "hasAgreedToTerms"
    static let sortOption = "sortOption"
    static let displayMode = "displayMode"
    static let missingVolumesMigrationDone = "isMissingVolumesMigrationDone"
}

let defaultPublisher = "選択なし"

let publishers = [defaultPublisher, "集英社（Shueisha）", "講談社（Kodansha）", "小学館（Shogakukan）", "秋田書店（Akita Shoten）", "角川書店（Kadokawa Shoten）", "白泉社（Hakusensha）", "双葉社（Futabasha）", "一迅社（Ichijinsha）", "芳文社（Houbunsha）", "スクウェア・エニックス（Square Enix）", "新潮社（Shinchosha）", "徳間書店（Tokuma Shoten）", "リブレ出版（Libre Publishing）", "幻冬舎コミックス（Gentosha Comics）", "大洋図書（Taiyo Tosho）", "マッグガーデン（Mag Garden）", "エンターブレイン（Enterbrain）", "芸文社（Geibunsha）", "コアミックス（Coremix）", "リイド社（Leed Publishing）", "ぶんか社（Bunkasha）", "宙出版（Ohzora Publishing）", "竹書房（Takeshobo）", "ビブロス（Biblos）", "イースト・プレス（East Press）", "その他"]

let graphHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 400 : 250
