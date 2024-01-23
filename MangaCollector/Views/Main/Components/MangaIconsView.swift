//  MangaIconsView.swift

import SwiftUI

struct MangaIconsView: View {
    var mangas: [Manga]
    var viewModel: MangaListViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(mangas, id: \.self) { manga in
                        NavigationLink(destination: MangaDetailView(manga: manga, viewModel: viewModel)) {
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    MangaImage(manga: manga)
                                        .frame(width: geometry.size.width / 3 - 50, height: 100)
                                        .shadow(radius: 5)

                                    if manga.totalOwnedVolumes > 0 {
                                        Text("\(manga.totalOwnedVolumes)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .offset(x: 10, y: -10)
                                    }
                                }

                                Text(manga.title ?? "Unknown Title")
                                    .font(.caption)
                                    .lineLimit(1)
                                Text(authorsString(manga.authors))
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2))
                        }
                    }
                }
                .padding()
            }
        }
    }

    private func authorsString(_ authors: NSSet?) -> String {
        guard let authorsSet = authors as? Set<Author>, !authorsSet.isEmpty else {
            return "著者不明"
        }
        return authorsSet.map { $0.name ?? "不明" }.joined(separator: " / ")
    }

    @ViewBuilder
    private func MangaImage(manga: Manga) -> some View {
        if let imageData = manga.image, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
        }
    }
}
