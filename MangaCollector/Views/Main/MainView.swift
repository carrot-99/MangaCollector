//  MainView.swift

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @AppStorage(UserDefaultsKey.displayMode) private var displayMode: DisplayMode = .list
    @State private var showingAddMangaDialog = false
    @State private var showingSettings = false
    @State private var mangasPendingDeletion: [Manga] = []
    @State private var exportedFile: ExportedFile?

    private var displayedMangas: [Manga] {
        viewModel.displayedMangas
    }

    private var totalOwnedVolumes: Int {
        displayedMangas.reduce(0) { $0 + Int($1.totalOwnedVolumes) }
    }

    var body: some View {
        VStack(spacing: 0) {
            TotalVolumesView(
                totalVolumes: totalOwnedVolumes,
                totalTitles: displayedMangas.count,
                filterOption: viewModel.filterOption,
                viewModel: viewModel
            )

            content
        }
        .searchable(text: $viewModel.searchText, prompt: "タイトル・著者で検索")
        .navigationBarTitle("漫画リスト", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("設定")
                if displayMode == .list && viewModel.canReorder && !viewModel.mangas.isEmpty {
                    EditButton()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                toolbarMenu
                Button(action: { showingAddMangaDialog = true }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("漫画を追加")
            }
        }
        .background(
            NavigationLink(destination: SettingsView(), isActive: $showingSettings) { EmptyView() }
                .hidden()
        )
        .sheet(isPresented: $showingAddMangaDialog) {
            AddMangaDialog(isPresented: $showingAddMangaDialog, viewModel: viewModel)
        }
        .sheet(item: $exportedFile) { file in
            ActivityView(activityItems: [file.url])
        }
        .alert(isPresented: Binding(
            get: { !mangasPendingDeletion.isEmpty },
            set: { if !$0 { mangasPendingDeletion = [] } }
        )) {
            Alert(
                title: Text(deletionMessage),
                message: Text("この操作は取り消せません。"),
                primaryButton: .destructive(Text("削除")) {
                    viewModel.deleteMangas(mangasPendingDeletion)
                    mangasPendingDeletion = []
                },
                secondaryButton: .cancel(Text("キャンセル")) {
                    mangasPendingDeletion = []
                }
            )
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.mangas.isEmpty {
            EmptyStateView(
                systemImage: "books.vertical",
                title: "まだ漫画が登録されていません",
                message: "右上の＋ボタンから追加しましょう",
                actionTitle: "漫画を追加",
                action: { showingAddMangaDialog = true }
            )
        } else if displayedMangas.isEmpty {
            EmptyStateView(
                systemImage: "magnifyingglass",
                title: "該当する作品がありません",
                message: "検索条件やフィルタを変更してください",
                actionTitle: "フィルタを解除",
                action: {
                    viewModel.filterOption = .all
                    viewModel.searchText = ""
                }
            )
        } else {
            switch displayMode {
            case .list:
                MangaListView(
                    mangas: displayedMangas,
                    viewModel: viewModel,
                    onDelete: { mangasPendingDeletion = $0 }
                )
                .padding(.bottom, 40)
            case .icons:
                MangaIconsView(mangas: displayedMangas, viewModel: viewModel)
                    .padding(.bottom, 40)
            }
        }
    }

    private var deletionMessage: String {
        if mangasPendingDeletion.count == 1, let manga = mangasPendingDeletion.first {
            return "「\(manga.displayTitle)」を削除しますか？"
        }
        return "\(mangasPendingDeletion.count)作品を削除しますか？"
    }

    private var toolbarMenu: some View {
        Menu {
            Picker("表示", selection: $displayMode) {
                ForEach(DisplayMode.allCases) { mode in
                    Label(mode.description, systemImage: mode.systemImage).tag(mode)
                }
            }

            Menu {
                Picker("フィルタ", selection: $viewModel.filterOption) {
                    ForEach(FilterOption.allCases) { option in
                        Text(option.description).tag(option)
                    }
                }
            } label: {
                Label("フィルタ：\(viewModel.filterOption.description)", systemImage: "line.3.horizontal.decrease.circle")
            }

            Menu {
                Picker("並び替え", selection: $viewModel.sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.description).tag(option)
                    }
                }
            } label: {
                Label("並び替え：\(viewModel.sortOption.description)", systemImage: "arrow.up.arrow.down")
            }

            Divider()

            Button(action: exportCSV) {
                Label("CSVで書き出す", systemImage: "square.and.arrow.up")
            }
            .disabled(displayedMangas.isEmpty)
        } label: {
            Image(systemName: viewModel.isFiltering ? "line.3.horizontal.decrease.circle.fill" : "ellipsis.circle")
        }
        .accessibilityLabel("表示オプション")
    }

    private func exportCSV() {
        let description = "\(viewModel.filterOption.description)・\(viewModel.sortOption.description)"
        do {
            let url = try CSVExporter.export(mangas: displayedMangas, conditionDescription: description)
            exportedFile = ExportedFile(url: url)
        } catch {
            print("Error exporting CSV: \(error.localizedDescription)")
        }
    }
}

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
