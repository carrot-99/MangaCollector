//  TotalVolumesView.swift

import SwiftUI

struct TotalVolumesView: View {
    var totalVolumes: Int
    var totalTitles: Int
    var filterOption: FilterOption
    @ObservedObject var viewModel: MangaListViewModel

    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Text("\(filterDescription): ")
                Text("\(totalTitles)作品")
                Text("\(totalVolumes)巻")
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2))
            .padding(.horizontal)
            
            NavigationLink(destination: GraphView(viewModel: viewModel)) {
                HStack{
                    Text("統計")
                    Image(systemName: "chevron.right")
                }
                .font(.caption2)
            }
            .padding(.trailing, 20)
        }
        .padding()
    }

    private var filterDescription: String {
        switch filterOption {
        case .all:
            return "全作品"
        case .ongoing:
            return "連載中"
        case .completed:
            return "完結済"
        case .incomplete:
            return "未完結"
        case .favorites:
            return "お気に入り"
        }
    }
}
