//  MangaIconsView.swift

import SwiftUI

struct MangaIconsView: View {
    var mangas: [Manga]
    @ObservedObject var viewModel: MangaListViewModel

    private var columns: [GridItem] {
        let numberOfColumns = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: numberOfColumns)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(mangas, id: \.objectID) { manga in
                    NavigationLink(destination: MangaDetailView(manga: manga, viewModel: viewModel)) {
                        MangaIconCell(manga: manga)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

private struct MangaIconCell: View {
    @ObservedObject var manga: Manga

    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .topTrailing) {
                cover
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .shadow(radius: 3)

                if manga.totalOwnedVolumes > 0 {
                    Text("\(manga.totalOwnedVolumes)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.blue))
                        .offset(x: 4, y: -6)
                }
            }

            Text(manga.displayTitle)
                .font(.caption)
                .lineLimit(1)
            Text(manga.authorsText)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 2))
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var cover: some View {
        if let imageData = manga.image, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ZStack {
                Color.secondary.opacity(0.15)
                Image(systemName: "book.closed")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            }
        }
    }
}
