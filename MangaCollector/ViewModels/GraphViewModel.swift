//  GraphViewModel.swift

import Foundation

class GraphViewModel {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func countTitlesByStatus(mangas: [Manga]) -> [PublicationStatus: Int] {
        var countDict: [PublicationStatus: Int] = [:]
        for status in PublicationStatus.allCases {
            let count = mangas.filter { $0.publicationStatus == status.rawValue }.count
            countDict[status] = count
        }
        return countDict
    }

    func countVolumesByStatus(mangas: [Manga]) -> [PublicationStatus: Int] {
        var countDict: [PublicationStatus: Int] = [:]
        for status in PublicationStatus.allCases {
            let totalVolumes = mangas.filter { $0.publicationStatus == status.rawValue }
                                     .reduce(0) { $0 + Int($1.totalOwnedVolumes) }
            countDict[status] = totalVolumes
        }
        return countDict
    }
}
