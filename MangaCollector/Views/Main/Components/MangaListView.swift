//  MangaListView.swift

import SwiftUI

struct MangaListView: View {
    var filteredMangas: [Manga]
    var viewModel: MangaListViewModel
    var deleteManga: (IndexSet) -> Void

    var body: some View {
        List {
            ForEach(filteredMangas, id: \.self) { manga in
                NavigationLink(destination: MangaDetailView(manga: manga, viewModel: viewModel)) {
                    MangaRow(manga: manga, viewModel: viewModel)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2))
                .padding(.horizontal)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .onMove(perform: moveManga)
            .onDelete(perform: deleteManga)
        }
        .listStyle(.plain)
    }
    
    private func moveManga(from source: IndexSet, to destination: Int) {
        var reorderedMangas = filteredMangas
        reorderedMangas.move(fromOffsets: source, toOffset: destination)

        // 並べ替えた順序を Core Data に保存
        for (index, manga) in reorderedMangas.enumerated() {
            viewModel.updateOrder(for: manga, newOrder: Int16(index + 1)) // 1から始まる順序
        }

        // 並べ替え後のリストを更新
        viewModel.fetchMangas()
    }
}
