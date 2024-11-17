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
                .foregroundColor(PublicationStatus(rawValue: manga.publicationStatus)?.color)
                .padding(5)
                .background(PublicationStatus(rawValue: manga.publicationStatus)?.color.opacity(0.2))
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text(manga.title ?? "Unknown Title")
                    .font(.headline)
                    .lineLimit(1)
//                if let authorNames = authorsString(manga.authors) { 
//                    Text(authorNames)
//                        .font(.caption)
//                        .lineLimit(1)
//                }
                if !manga.authorsArray.isEmpty {
                    Text(manga.authorsArray.joined(separator: " / "))
                        .font(.body)
                        .lineLimit(1)
                }
            }
            Spacer()
            VStack{
                Text("総計：\(manga.calculatedOwnedVolumes)")
                    .font(.headline)
                Text("最新：\(manga.ownedVolumes)")
                    .font(.subheadline)
            }
        }
        .shadow(radius: 10)
    }
    
    private func authorsString(_ authors: NSSet?) -> String? {
        guard let authorsSet = authors as? Set<Author>, !authorsSet.isEmpty else {
            return nil
        }
        return authorsSet.map { $0.name ?? "不明" }.joined(separator: " / ")
    }
}
