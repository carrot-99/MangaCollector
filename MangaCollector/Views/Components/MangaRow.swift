//  MangaRow.swift

import Foundation
import SwiftUI

struct MangaRow: View {
    var manga: Manga
    @ObservedObject var viewModel: MangaListViewModel

    var body: some View {
        HStack {
            Text(PublicationStatus(rawValue: manga.publicationStatus)?.description ?? "不明")
                .font(.caption)
                .foregroundColor(colorForStatus(manga.publicationStatus))
                .padding(5)
                .background(colorForStatus(manga.publicationStatus).opacity(0.2))
                .cornerRadius(5)
            Text(manga.title ?? "Unknown Title")
                .font(.headline)
                .lineLimit(1)
            Spacer()
            Text("\(manga.calculatedOwnedVolumes)")
                .font(.subheadline)
        }
    }
    
    private func colorForStatus(_ status: Int16) -> Color {
        switch PublicationStatus(rawValue: status) {
        case .ongoing:
            return .green
        case .completed:
            return .blue
        case .incomplete:
            return .red
        default:
            return .gray
        }
    }
}
