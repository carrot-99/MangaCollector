//  MainView.swift

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @State private var showingAddMangaDialog = false
    @State private var filterOption: FilterOption = .all
    @State private var displayMode: DisplayMode = .list
    @State private var searchText = ""
    @State private var showSearchBar = false
    
    var totalOwnedVolumes: Int {
        filteredMangas.reduce(0) { total, manga in
            total + Int(manga.totalOwnedVolumes)
        }
    }

    var filteredMangas: [Manga] {
        viewModel.mangas.filter { manga in
            (searchText.isEmpty || manga.title?.localizedCaseInsensitiveContains(searchText) == true)
        }.filter { manga in
            switch filterOption {
            case .all:
                return true
            case .ongoing:
                return manga.publicationStatus == PublicationStatus.ongoing.rawValue
            case .completed:
                return manga.publicationStatus == PublicationStatus.completed.rawValue
            case .incomplete:
                return manga.publicationStatus == PublicationStatus.incomplete.rawValue
            case .favorites:
                return manga.favorite
            }
        }
    }
    
    var body: some View {
        VStack {
            // 総数
            TotalVolumesView(totalVolumes: totalOwnedVolumes, totalTitles: filteredMangas.count, filterOption: filterOption, viewModel: viewModel)
            
            if showSearchBar {
                SearchBar(text: $searchText).padding()
            }

            switch displayMode {
            case .list:
                MangaListView(
                    filteredMangas: filteredMangas,
                    viewModel: viewModel,
                    deleteManga: deleteManga
                )
                    .padding(.bottom, 40)
            case .icons:
                MangaIconsView(mangas: filteredMangas, viewModel: viewModel)
                    .padding(.bottom, 40)
            }
        }
        .navigationBarTitle("漫画リスト", displayMode: .inline)
        .navigationBarItems(leading: HStack {
            addButton
            if viewModel.sortOption == .defaultOrder && filterOption == .all {
                EditButton()
            }
        }, trailing: toolbarMenu)
        .sheet(isPresented: $showingAddMangaDialog) {
            AddMangaDialog(isPresented: $showingAddMangaDialog, viewModel: viewModel)
        }
    }
    
    var addButton: some View {
        Button(action: { showingAddMangaDialog = true }) {
            Image(systemName: "plus")
        }
    }
    
    var toolbarMenu: some View {
        Menu {
            Button(showSearchBar ? "検索バーを隠す" : "検索バーを表示") {
                showSearchBar.toggle()
            }
            Divider()
            filterMenu
            Divider()
            sortMenu
            Divider()
            displayModeMenu
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    var filterMenu: some View {
        Group {
            Button("全作品") {
                if filterOption != .all {
                    filterOption = .all
                }
            }.disabled(filterOption == .all)
            Button("お気に入り") {
                if filterOption != .favorites {
                    filterOption = .favorites
                }
            }.disabled(filterOption == .favorites)
            Button("連載中") {
                if filterOption != .ongoing {
                    filterOption = .ongoing
                }
            }.disabled(filterOption == .ongoing)
            Button("完結済み") {
                if filterOption != .completed {
                    filterOption = .completed
                }
            }.disabled(filterOption == .completed)
            Button("未完結") {
                if filterOption != .incomplete {
                    filterOption = .incomplete
                }
            }.disabled(filterOption == .incomplete)
        }
    }

    var sortMenu: some View {
        Group {
            Button("デフォルト順") {
                if viewModel.sortOption != .defaultOrder {
                    viewModel.sortOption = .defaultOrder
                    viewModel.sortMangas()
                }
            }.disabled(viewModel.sortOption == .defaultOrder)
            Button("タイトル昇順") {
                if viewModel.sortOption != .titleAscending {
                    viewModel.sortOption = .titleAscending
                    viewModel.sortMangas()
                }
            }.disabled(viewModel.sortOption == .titleAscending)
            Button("タイトル降順") {
                if viewModel.sortOption != .titleDescending {
                    viewModel.sortOption = .titleDescending
                    viewModel.sortMangas()
                }
            }.disabled(viewModel.sortOption == .titleDescending)
            Button("巻数昇順") {
                if viewModel.sortOption != .volumeAscending {
                    viewModel.sortOption = .volumeAscending
                    viewModel.sortMangas()
                }
            }.disabled(viewModel.sortOption == .volumeAscending)
            Button("巻数降順") {
                if viewModel.sortOption != .volumeDescending {
                    viewModel.sortOption = .volumeDescending
                    viewModel.sortMangas()
                }
            }.disabled(viewModel.sortOption == .volumeDescending)
        }
    }

    var displayModeMenu: some View {
        Button(displayMode == .list ? "アイコン表示" : "リスト表示") {
            displayMode = displayMode == .list ? .icons : .list
        }
    }
    
    private func deleteManga(at offsets: IndexSet) {
        offsets.map { filteredMangas[$0] }.forEach { manga in
            viewModel.deleteManga(manga: manga)
        }
    }
    
    private func exportCSV() {
        let csvText = generateCSVText()
        let activityController = UIActivityViewController(activityItems: [csvText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    private func generateCSVText() -> String {
        var csvText = "タイトル,所有巻数\n"
        for manga in filteredMangas {
            if let title = manga.title?.replacingOccurrences(of: ",", with: ";") {
                let ownedVolumes = manga.totalOwnedVolumes
                csvText += "\(title),\(ownedVolumes)\n"
            }
        }

        let filteredTotalOwnedVolumes = filteredMangas.reduce(0) { $0 + Int($1.totalOwnedVolumes) }
        let filterDescription = filterOptionDescription()
        let sortDescription = sortOptionDescription()
        csvText += "\n\(filterDescription)、\(sortDescription)に基づいた総所有巻数: \(filteredTotalOwnedVolumes)"
        return csvText
    }
    
    private func filterOptionDescription() -> String {
        switch filterOption {
        case .all:
            return "全作品"
        case .ongoing:
            return "連載中作品"
        case .completed:
            return "完結済作品"
        case .incomplete:
            return "未完結作品"
        case .favorites:
            return "お気に入り"
        }
    }

    private func sortOptionDescription() -> String {
        switch viewModel.sortOption {
        case .defaultOrder:
            return "登録順"
        case .titleAscending:
            return "タイトル昇順"
        case .titleDescending:
            return "タイトル降順"
        case .volumeAscending:
            return "巻数昇順"
        case .volumeDescending:
            return "巻数降順"
        }
    }
}
