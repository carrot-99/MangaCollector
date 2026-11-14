//  Manga.swift

import Foundation

extension Manga {
    var displayTitle: String {
        title ?? "Unknown Title"
    }

    var status: PublicationStatus {
        PublicationStatus(rawValue: publicationStatus) ?? .ongoing
    }

    var authorsArray: [String] {
        get {
            return (self.author as? [String]) ?? []
        }
        set {
            self.author = newValue as NSObject
        }
    }

    var authorsText: String {
        authorsArray.joined(separator: " / ")
    }

    /// 不足している巻番号（昇順・重複なし）
    var missingVolumeNumbers: [Int] {
        get {
            return (self.missingVolumesList as? [NSNumber])?.map { $0.intValue } ?? []
        }
        set {
            self.missingVolumesList = Array(Set(newValue)).sorted().map { NSNumber(value: $0) } as NSObject
        }
    }

    var otherTitlesArray: [OtherTitle] {
        let set = otherTitles as? Set<OtherTitle> ?? []
        return set.sorted { $0.title ?? "" < $1.title ?? "" }
    }

    var calculatedOwnedVolumes: Int {
        Manga.totalOwnedVolumes(
            latestVolume: Int(ownedVolumes),
            missingVolumes: missingVolumeNumbers,
            otherTitles: otherTitlesArray
        )
    }

    func updateTotalOwnedVolumes() {
        self.totalOwnedVolumes = Int16(self.calculatedOwnedVolumes)
    }

    /// 総所有巻数 = 最新巻 − 不足巻（最新巻以下のもの） + 外伝などの巻数
    static func totalOwnedVolumes(latestVolume: Int, missingVolumes: [Int], otherTitles: [OtherTitle]) -> Int {
        let missingCount = missingVolumes.filter { $0 >= 1 && $0 <= latestVolume }.count
        let otherTitlesTotal = otherTitles.reduce(0) { $0 + Int($1.ownedVolumes) }
        return max(latestVolume - missingCount + otherTitlesTotal, 0)
    }
}

extension Array where Element == Int {
    /// 連続する巻をまとめた表記を返す（例: [1, 2, 3, 5] → "1〜3巻, 5巻"）
    var volumeRangesDescription: String {
        let sortedVolumes = Array(Set(self)).sorted()
        guard var start = sortedVolumes.first else { return "" }

        var ranges: [String] = []
        var previous = start
        func appendRange() {
            ranges.append(start == previous ? "\(start)巻" : "\(start)〜\(previous)巻")
        }
        for volume in sortedVolumes.dropFirst() {
            if volume == previous + 1 {
                previous = volume
            } else {
                appendRange()
                start = volume
                previous = volume
            }
        }
        appendRange()
        return ranges.joined(separator: ", ")
    }
}
