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
            .onDelete(perform: deleteManga)
        }
        .listStyle(.plain)
    }
}
