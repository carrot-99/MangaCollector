//  MangaIconsView.swift

import SwiftUI

struct MangaIconsView: View {
    var mangas: [Manga]
    var viewModel: MangaListViewModel

    private var columns: [GridItem] {
        let numberOfColumns = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3
        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(mangas, id: \.self) { manga in
                        NavigationLink(destination: MangaDetailView(manga: manga, viewModel: viewModel)) {
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    MangaImage(manga: manga)
                                        .frame(width: geometry.size.width / CGFloat(columns.count) - 50, height: 100)
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
            return ""
        }
        return authorsSet.map { $0.name ?? "" }.joined(separator: " / ")
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
