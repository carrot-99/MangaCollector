//  MangaRow.swift

import SwiftUI

struct MangaRow: View {
    @ObservedObject var manga: Manga

    var body: some View {
        HStack(spacing: 10) {
            StatusBadge(status: manga.status)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(manga.displayTitle)
                        .font(.headline)
                        .lineLimit(1)
                    if manga.favorite {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundColor(.red)
                            .accessibilityLabel("お気に入り")
                    }
                }
                if !manga.authorsArray.isEmpty {
                    Text(manga.authorsText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                if !manga.missingVolumeNumbers.isEmpty {
                    Text("不足：\(manga.missingVolumeNumbers.volumeRangesDescription)")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("総計：\(manga.totalOwnedVolumes)")
                    .font(.headline)
                Text("最新：\(manga.ownedVolumes)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StatusBadge: View {
    let status: PublicationStatus

    var body: some View {
        Text(status.description)
            .font(.caption)
            .foregroundColor(status.color)
            .padding(5)
            .background(status.color.opacity(0.2))
            .cornerRadius(5)
    }
}
