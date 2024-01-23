//  NavigationBarItemsView.swift

import SwiftUI

struct NavigationBarItemsView: View {
    @ObservedObject var viewModel: MangaListViewModel
    var onExportCSV: () -> Void
    var onAddManga: () -> Void

    var body: some View {
        HStack {
            // 設定アイコン
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape")
            }

            // CSVエクスポート
            Button(action: onExportCSV) {
                Image(systemName: "square.and.arrow.up")
            }

            // 漫画追加ボタン
            Button(action: onAddManga) {
                Image(systemName: "plus")
            }
        }
    }
}
