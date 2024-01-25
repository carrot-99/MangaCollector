//  PublisherGraphView.swift

import SwiftUI
import SwiftUICharts

struct PublisherGraphView: View {
    @ObservedObject var viewModel: MangaListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // 出版社別の作品数の円グラフ
            Label("出版社別作品数", systemImage: "chart.pie")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            DoughnutChart(chartData: chartDataForTitles())
                .padding()
                .frame(height: graphHeight)

            Spacer()
                .padding(50)

            // 出版社別の巻数の円グラフ
            Label("出版社別巻数", systemImage: "chart.pie")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            DoughnutChart(chartData: chartDataForVolumes())
                .padding()
                .frame(height: graphHeight)
        }
        .padding(.horizontal)
    }

    private func chartDataForTitles() -> DoughnutChartData {
        let colors = [Color.red, Color.green, Color.blue, Color.orange, Color.purple,
                      Color.yellow, Color.pink, Color.cyan, Color.gray, Color.brown]
        let countsByPublisher = countItemsByPublisher { $0.count }
        let sortedCounts = countsByPublisher.sorted { $0.value > $1.value }

        var topPublishers: [(key: String, value: Int)] = []
        var otherCount = 0
        var includedOther = false

        for (index, count) in sortedCounts.enumerated() {
            if index < 5 || (index >= 5 && count.value == sortedCounts[4].value) {
                topPublishers.append(count)
            } else {
                otherCount += count.value
                includedOther = true
            }
        }

        var dataPoints: [PieChartDataPoint] = topPublishers.enumerated().map { index, count in
            let color = colors[index % colors.count]
            let publisherName = japanesePublisherName(count.key).abbreviateIfNeeded()
            return PieChartDataPoint(value: Double(count.value),
                                     description: publisherName,
                                     colour: color,
                                     label: .label(text: "\(publisherName)\n\(count.value)作品", font: .caption2))
        }

        if includedOther {
            dataPoints.append(PieChartDataPoint(value: Double(otherCount),
                                                description: "ほか",
                                                colour: Color.gray,
                                                label: .label(text: "ほか\n\(otherCount)作品", font: .caption2)))
        }

        let dataSet = PieDataSet(dataPoints: dataPoints, legendTitle: "作品数")
        let metadata = ChartMetadata(title: "出版社別作品数", subtitle: "")
        let chartStyle = DoughnutChartStyle(strokeWidth: 15)
        return DoughnutChartData(dataSets: dataSet, metadata: metadata, chartStyle: chartStyle, noDataText: Text("データがありません"))
    }

    private func chartDataForVolumes() -> DoughnutChartData {
        let colors = [Color.red, Color.green, Color.blue, Color.orange, Color.purple,
                      Color.yellow, Color.pink, Color.cyan, Color.gray, Color.brown]
        let countsByPublisher = countItemsByPublisher { $0.reduce(0) { $0 + Int($1.totalOwnedVolumes) } }
        let sortedCounts = countsByPublisher.sorted { $0.value > $1.value }

        var topPublishers: [(key: String, value: Int)] = []
        var otherCount = 0
        var includedOther = false

        for (index, count) in sortedCounts.enumerated() {
            if index < 5 || (index >= 5 && count.value == sortedCounts[4].value) {
                topPublishers.append(count)
            } else {
                otherCount += count.value
                includedOther = true
            }
        }

        var dataPoints: [PieChartDataPoint] = topPublishers.enumerated().map { index, count in
            let color = colors[index % colors.count]
            let publisherName = japanesePublisherName(count.key).abbreviateIfNeeded()
            return PieChartDataPoint(value: Double(count.value),
                                     description: publisherName,
                                     colour: color,
                                     label: .label(text: "\(publisherName)\n\(count.value)巻", font: .caption2))
        }

        if includedOther {
            dataPoints.append(PieChartDataPoint(value: Double(otherCount),
                                                description: "ほか",
                                                colour: Color.gray,
                                                label: .label(text: "ほか\n\(otherCount)巻", font: .caption2)))
        }

        let dataSet = PieDataSet(dataPoints: dataPoints, legendTitle: "巻数")
        let metadata = ChartMetadata(title: "出版社別巻数", subtitle: "")
        let chartStyle = DoughnutChartStyle(strokeWidth: 15)
        return DoughnutChartData(dataSets: dataSet, metadata: metadata, chartStyle: chartStyle, noDataText: Text("データがありません"))
    }

    private func countItemsByPublisher(_ countMethod: ([Manga]) -> Int) -> [(key: String, value: Int)] {
        let groupedByPublisher = Dictionary(grouping: viewModel.mangas, by: { $0.publisher ?? "未指定" })
        return groupedByPublisher.mapValues(countMethod).sorted { $0.value > $1.value }
    }
    
    private func japanesePublisherName(_ publisher: String) -> String {
        let components = publisher.components(separatedBy: "（")
        if let japaneseName = components.first {
            return japaneseName
        }
        return publisher
    }
}

extension String {
    func abbreviateIfNeeded() -> String {
        if self.count > 7 {
            return String(self.prefix(6)) + "..."
        }
        return self
    }
}
