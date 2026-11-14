//  CSVExporter.swift

import SwiftUI

/// 書き出したファイル（シート表示用）
struct ExportedFile: Identifiable {
    let id = UUID()
    let url: URL
}

enum CSVExporter {
    private static let header = ["タイトル", "著者", "出版社", "連載状況", "最新巻", "不足巻", "総所有巻数", "お気に入り", "メモ"]

    /// 作品一覧を CSV ファイルとして一時ディレクトリに書き出し、その URL を返す
    static func export(mangas: [Manga], conditionDescription: String) throws -> URL {
        let text = makeCSV(mangas: mangas, conditionDescription: conditionDescription)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("manga_list_\(formatter.string(from: Date())).csv")
        // Excel で文字化けしないよう BOM 付き UTF-8 で保存する
        var data = Data([0xEF, 0xBB, 0xBF])
        data.append(Data(text.utf8))
        try data.write(to: url, options: .atomic)
        return url
    }

    static func makeCSV(mangas: [Manga], conditionDescription: String) -> String {
        var rows = [header]
        for manga in mangas {
            rows.append([
                manga.displayTitle,
                manga.authorsText,
                manga.publisher ?? "",
                manga.status.description,
                "\(manga.ownedVolumes)",
                manga.missingVolumeNumbers.volumeRangesDescription,
                "\(manga.totalOwnedVolumes)",
                manga.favorite ? "○" : "",
                manga.notes ?? ""
            ])
        }
        let total = mangas.reduce(0) { $0 + Int($1.totalOwnedVolumes) }
        rows.append([])
        rows.append(["\(conditionDescription)の合計", "\(mangas.count)作品", "\(total)巻"])
        return rows.map { $0.map(escape).joined(separator: ",") }.joined(separator: "\r\n") + "\r\n"
    }

    private static func escape(_ field: String) -> String {
        guard field.contains(where: { $0 == "," || $0 == "\"" || $0 == "\n" || $0 == "\r" }) else {
            return field
        }
        return "\"" + field.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}

/// UIActivityViewController のラッパー
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
