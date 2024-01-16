//  GraphView.swift

import SwiftUI
import SwiftUICharts

struct GraphView: View {
    @ObservedObject var viewModel: MangaListViewModel

    var body: some View {
        ScrollView{
            if viewModel.mangas.isEmpty {
                Text("表示するデータがありません")
                    .foregroundColor(.white)
                    .padding()
            } else {
                VStack {
                    VStack(alignment: .leading) {
                        // 連載状況別の作品数の円グラフ
                        Label("連載状況別作品数", systemImage: "chart.pie")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 1)
                        DoughnutChart(chartData: chartDataForTitles())
                            .padding(.top, 20)
                            .frame(height: 250)
                    }
                    .padding(.bottom, 50)
                    
                    VStack(alignment: .leading) {
                        // 連載状況別の巻数の円グラフ
                        Label("連載状況別巻数", systemImage: "chart.pie")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 1)
                        DoughnutChart(chartData: chartDataForVolumes())
                            .padding(.top, 20)
                            .frame(height: 250)
                    }
                }
            }
        }
        .padding(.top, 20)
        .navigationTitle("統計")
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    private func chartDataForTitles() -> DoughnutChartData {
        let counts = viewModel.countTitlesByStatus()
        var legends: [LegendData] = []
        let dataPoints = counts.map { (status, count) -> PieChartDataPoint in
            let legend = LegendData(id: UUID(),
                                    legend: status.description,
                                    colour: ColourStyle(colour: colorForStatus(status)),
                                    strokeStyle: nil,
                                    prioity: 1,
                                    chartType: .pie)
            legends.append(legend)
            return PieChartDataPoint(
                value: Double(count),
                description: status.description,
                colour: colorForStatus(status),
                label: .label(text: "\(status.description)\n\(count)作品", colour: .white, font: .caption)
            )
        }
        let dataSet = PieDataSet(dataPoints: dataPoints, legendTitle: "作品数")
        let chartStyle = DoughnutChartStyle(strokeWidth: 15)
        let metadata = ChartMetadata(title: "作品数", subtitle: "連載状況別")
        let chartData = DoughnutChartData(dataSets: dataSet, metadata: metadata, chartStyle: chartStyle, noDataText: Text("データがありません"))
        return chartData
    }
    
    private func chartDataForVolumes() -> DoughnutChartData {
        let counts = viewModel.countVolumesByStatus()
        var legends: [LegendData] = []
        let dataPoints = counts.map { (status, count) -> PieChartDataPoint in
            let legend = LegendData(id: UUID(),
                                    legend: status.description,
                                    colour: ColourStyle(colour: colorForStatus(status)),
                                    strokeStyle: nil,
                                    prioity: 1,
                                    chartType: .pie)
            legends.append(legend)
            return PieChartDataPoint(
                value: Double(count),
                description: status.description,
                colour: colorForStatus(status),
                label: .label(text: "\(status.description)\n\(count)巻", colour: .white, font: .caption)
            )
        }
        let dataSet = PieDataSet(dataPoints: dataPoints, legendTitle: "巻数")
        let metadata = ChartMetadata(title: "巻数", subtitle: "連載状況別")
        let chartStyle = DoughnutChartStyle(strokeWidth: 15)
        let chartData = DoughnutChartData(dataSets: dataSet, metadata: metadata, chartStyle: chartStyle, noDataText: Text("データがありません"))
        return chartData
    }

    // 連載状況に応じた色を返す
    private func colorForStatus(_ status: PublicationStatus) -> Color {
        switch status {
        case .ongoing:
            return Color.cyan
        case .completed:
            return Color.pink
        case .incomplete:
            return Color.orange
        }
    }
}
