//  PublicationStatusGraphView.swift

import SwiftUI
import SwiftUICharts

struct PublicationStatusGraphView: View {
    @ObservedObject var viewModel: MangaListViewModel
    
    var body: some View {
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
             
             Spacer()
             
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
    
    private func chartDataForTitles() -> DoughnutChartData {
        var dataPoints: [PieChartDataPoint] = []

        // 各状況に応じたデータポイントの追加
        if let ongoingCount = viewModel.countTitlesByStatus()[.ongoing] {
            dataPoints.append(createTitleDataPoint(for: .ongoing, count: ongoingCount))
        }
        if let completedCount = viewModel.countTitlesByStatus()[.completed] {
            dataPoints.append(createTitleDataPoint(for: .completed, count: completedCount))
        }
        if let incompleteCount = viewModel.countTitlesByStatus()[.incomplete] {
            dataPoints.append(createTitleDataPoint(for: .incomplete, count: incompleteCount))
        }

        // チャートデータの設定
        let dataSet = PieDataSet(dataPoints: dataPoints, legendTitle: "作品数")
        let metadata = ChartMetadata(title: "作品数", subtitle: "連載状況別")
        let chartStyle = DoughnutChartStyle(strokeWidth: 15)
        return DoughnutChartData(dataSets: dataSet, metadata: metadata, chartStyle: chartStyle, noDataText: Text("データがありません"))
    }

    private func chartDataForVolumes() -> DoughnutChartData {
        var dataPoints: [PieChartDataPoint] = []

        // 各状況に応じたデータポイントの追加
        if let ongoingCount = viewModel.countVolumesByStatus()[.ongoing] {
            dataPoints.append(createVolumeDataPoint(for: .ongoing, count: ongoingCount))
        }
        if let completedCount = viewModel.countVolumesByStatus()[.completed] {
            dataPoints.append(createVolumeDataPoint(for: .completed, count: completedCount))
        }
        if let incompleteCount = viewModel.countVolumesByStatus()[.incomplete] {
            dataPoints.append(createVolumeDataPoint(for: .incomplete, count: incompleteCount))
        }

        // チャートデータの設定
        let dataSet = PieDataSet(dataPoints: dataPoints, legendTitle: "巻数")
        let metadata = ChartMetadata(title: "巻数", subtitle: "連載状況別")
        let chartStyle = DoughnutChartStyle(strokeWidth: 15)
        return DoughnutChartData(dataSets: dataSet, metadata: metadata, chartStyle: chartStyle, noDataText: Text("データがありません"))
    }

    private func createTitleDataPoint(for status: PublicationStatus, count: Int) -> PieChartDataPoint {
        return PieChartDataPoint(
            value: Double(count),
            description: status.description,
            colour: status.color,
            label: .label(text: "\(status.description)\n\(count)作品", font: .caption)
        )
    }

    private func createVolumeDataPoint(for status: PublicationStatus, count: Int) -> PieChartDataPoint {
        return PieChartDataPoint(
            value: Double(count),
            description: status.description,
            colour: status.color,
            label: .label(text: "\(status.description)\n\(count)巻", font: .caption)
        )
    }
}
