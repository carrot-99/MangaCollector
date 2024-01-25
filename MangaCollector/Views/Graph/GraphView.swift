//  GraphView.swift

import SwiftUI
import SwiftUICharts

struct GraphView: View {
    @ObservedObject var viewModel: MangaListViewModel
    @State private var selectedTab: GraphTab = .publicationStatus

    var body: some View {
        ScrollView{
            Picker("グラフタイプ", selection: $selectedTab) {
                Text("連載状況別").tag(GraphTab.publicationStatus)
                Text("出版社別").tag(GraphTab.publisher)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if viewModel.mangas.isEmpty {
                Text("表示するデータがありません")
                    .padding()
            } else {
                VStack {
                    if selectedTab == .publicationStatus {
                        PublicationStatusGraphView(viewModel: viewModel)
                    } else {
                        PublisherGraphView(viewModel: viewModel)
                    }
                }
            }
        }
        .padding(.top, 20)
        .navigationTitle("統計")
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
