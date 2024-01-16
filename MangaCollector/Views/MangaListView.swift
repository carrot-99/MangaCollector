//  MangaListView.swift

import SwiftUI

struct MangaListView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @State private var showingAddMangaDialog = false
    @State private var activeSheet: ActiveSheet?
    @State private var filterOption: FilterOption = .all
    
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
        }
    }

    var body: some View {
        VStack {
            // 総数
            NavigationLink(destination: GraphView(viewModel: viewModel)) {
                HStack {
                    Text("総巻数: \(totalOwnedVolumes)")
                        .foregroundColor(.white)
                    
                    Spacer() // 左のテキストと右のアイコンの間にスペースを追加
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2))
                .padding(.horizontal)
            }
            .padding()
            
            // 漫画リスト
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
            .padding(.bottom, 50)
        }
        .background(Color.black)
        .foregroundColor(.white)
        .navigationBarTitle("漫画リスト", displayMode: .inline)
        .navigationBarItems(
            leading: 
                HStack {
                    // 設定アイコン
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                    
                    Button(action: {
                        let text = generateCSVText()
                        let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                },
            trailing: 
                HStack {
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
                    // 漫画追加ボタン
                    Button(action: {
                        self.showingAddMangaDialog = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
        )
        .sheet(isPresented: $showingAddMangaDialog) {
            AddMangaDialog(viewModel: viewModel)
        }
        .actionSheet(item: $activeSheet) { sheet in
            switch sheet {
                // ソート用アクションシート
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
                // フィルター用アクションシート
            case .filter:
                return ActionSheet(title: Text("フィルター選択"), buttons: [
                    .default(Text("全作品")) { filterOption = .all },
                    .default(Text("連載中作品")) { filterOption = .ongoing },
                    .default(Text("完結済作品")) { filterOption = .completed },
                    .default(Text("未完結作品")) { filterOption = .incomplete },
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
    
    private func calculateTitleSlices() -> [PieSliceData] {
        let counts = viewModel.countTitlesByStatus()
        return counts.map { status, count in
            PieSliceData(value: Double(count), label: "label", color: color(for: status))
        }
    }

    private func calculateVolumeSlices() -> [PieSliceData] {
        let counts = viewModel.countVolumesByStatus()
        return counts.map { status, count in
            PieSliceData(value: Double(count), label: "label", color: color(for: status))
        }
    }
    
    private func color(for status: PublicationStatus) -> Color {
        switch status {
        case .ongoing:
            return .red
        case .completed:
            return .green
        case .incomplete:
            return .yellow
        }
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
