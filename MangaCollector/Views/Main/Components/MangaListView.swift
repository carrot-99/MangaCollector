//  MangaListView.swift

import SwiftUI

struct MangaListView: View {
    var mangas: [Manga]
    @ObservedObject var viewModel: MangaListViewModel
    /// 削除確認を求める
    var onDelete: ([Manga]) -> Void

    var body: some View {
        List {
            ForEach(mangas, id: \.objectID) { manga in
                NavigationLink(destination: MangaDetailView(manga: manga, viewModel: viewModel)) {
                    MangaRow(manga: manga)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2))
                .padding(.horizontal)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        viewModel.incrementOwnedVolumes(of: manga)
                    } label: {
                        Label("+1巻", systemImage: "plus")
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        onDelete([manga])
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                }
            }
            .onMove(perform: viewModel.canReorder ? viewModel.moveMangas : nil)
            .onDelete { offsets in
                onDelete(offsets.map { mangas[$0] })
            }
        }
        .listStyle(.plain)
    }
}
