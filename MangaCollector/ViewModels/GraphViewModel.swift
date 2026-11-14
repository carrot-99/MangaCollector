//  GraphViewModel.swift

import Foundation

/// 統計グラフ用の集計処理
enum GraphViewModel {
    static func countTitlesByStatus(mangas: [Manga]) -> [PublicationStatus: Int] {
        Dictionary(grouping: mangas, by: \.status).mapValues(\.count)
    }

    static func countVolumesByStatus(mangas: [Manga]) -> [PublicationStatus: Int] {
        Dictionary(grouping: mangas, by: \.status).mapValues { group in
            group.reduce(0) { $0 + Int($1.totalOwnedVolumes) }
        }
    }
}
