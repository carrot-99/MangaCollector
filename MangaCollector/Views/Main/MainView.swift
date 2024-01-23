//  MainView.swift

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @State private var showingAddMangaDialog = false
    @State private var activeSheet: ActiveSheet?
    @State private var filterOption: FilterOption = .all
    @State private var displayMode: DisplayMode = .list
    
    var totalOwnedVolumes: Int {
        filteredMangas.reduce(0) { total, manga in
            total + Int(manga.totalOwnedVolumes)
        }
    }

    var filteredMangas: [Manga] {
        switch filterOption {
        case .all:
            return viewModel.mangas
        case .ongoing:
            return viewModel.mangas.filter { $0.publicationStatus == PublicationStatus.ongoing.rawValue }
        case .completed:
            return viewModel.mangas.filter { $0.publicationStatus == PublicationStatus.completed.rawValue }
        case .incomplete:
            return viewModel.mangas.filter { $0.publicationStatus == PublicationStatus.incomplete.rawValue }
        case .favorites:
            return viewModel.mangas.filter { $0.favorite }
        }
    }
    
    var body: some View {
        VStack {
            // 総数
            TotalVolumesView(totalVolumes: totalOwnedVolumes, totalTitles: filteredMangas.count, filterOption: filterOption, viewModel: viewModel)

            switch displayMode {
            case .list:
                MangaListView(filteredMangas: filteredMangas, viewModel: viewModel, deleteManga: deleteManga)
            case .icons:
                MangaIconsView(mangas: filteredMangas, viewModel: viewModel)
            }
        }
        .navigationBarTitle("漫画リスト", displayMode: .inline)
        .navigationBarItems(
            leading: NavigationBarItemsView(
                viewModel: viewModel,
                onExportCSV: exportCSV,
                onAddManga: { showingAddMangaDialog = true }
            ),
            trailing:
                HStack {
                    // 表示モード切り替えアイコン
                    Button(action: {
                        displayMode = displayMode == .list ? .icons : .list
                    }) {
                        Image(systemName: displayMode == .list ? "rectangle.grid.2x2" : "list.dash")
                    }
                    // フィルターアイコン
                    Button(action: {
                        self.activeSheet = .filter
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                    // ソートアイコン
                    Button(action: {
                        self.activeSheet = .sort
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
        )
        .sheet(isPresented: $showingAddMangaDialog) {
            AddMangaDialog(viewModel: viewModel)
        }
        .actionSheet(item: $activeSheet) { sheet in
            switch sheet {
            case .sort:
                return ActionSheet(title: Text("ソート順を選択"), buttons: [
                    .default(Text("タイトル昇順")) {
                        viewModel.sortOption = .titleAscending
                        viewModel.sortMangas()
                    },
                    .default(Text("タイトル降順")) {
                        viewModel.sortOption = .titleDescending
                        viewModel.sortMangas()
                    },
                    .default(Text("巻数昇順")) {
                        viewModel.sortOption = .volumeAscending
                        viewModel.sortMangas()
                    },
                    .default(Text("巻数降順")) {
                        viewModel.sortOption = .volumeDescending
                        viewModel.sortMangas()
                    },
                    .cancel()
                ])
            case .filter:
                return ActionSheet(title: Text("フィルター選択"), buttons: [
                    .default(Text("全作品")) { filterOption = .all },
                    .default(Text("連載中作品")) { filterOption = .ongoing },
                    .default(Text("完結済作品")) { filterOption = .completed },
                    .default(Text("未完結作品")) { filterOption = .incomplete },
                    .default(Text("お気に入り")) { filterOption = .favorites },
                    .cancel()
                ])
            }
        }
    }
    
    private func deleteManga(at offsets: IndexSet) {
        offsets.forEach { index in
            let manga = viewModel.mangas[index]
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
