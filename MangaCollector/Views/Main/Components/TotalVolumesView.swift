//  TotalVolumesView.swift

import SwiftUI

struct TotalVolumesView: View {
    var totalVolumes: Int
    var totalTitles: Int
    var filterOption: FilterOption
    @ObservedObject var viewModel: MangaListViewModel

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(filterOption.description)：")
            Text("\(totalTitles)作品")
            Text("\(totalVolumes)巻")
                .bold()
            Spacer()
            NavigationLink(destination: GraphView(viewModel: viewModel)) {
                HStack(spacing: 2) {
                    Image(systemName: "chart.pie")
                    Text("統計")
                }
                .font(.caption)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 2))
        .padding()
    }
}
