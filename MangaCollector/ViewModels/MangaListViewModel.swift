//  MangaListViewModel.swift

import Foundation
import CoreData

class MangaListViewModel: ObservableObject {
    @Published var mangas: [Manga] = []
    @Published var sortOption: SortOption = .titleAscending
    @Published var duplicateVolumeAlert = false
    private let databaseService: DatabaseService

    init(context: NSManagedObjectContext) {
        self.databaseService = DatabaseService(context: context)
        fetchMangas()
    }

    // MARK: - Manga
    
    func fetchMangas() {
        databaseService.fetchMangas { [weak self] fetchedMangas in
            self?.mangas = fetchedMangas ?? []
        }
    }
    
    func sortMangas() {
        switch sortOption {
        case .defaultOrder:
            break
        case .titleAscending:
            mangas.sort { $0.title ?? "" < $1.title ?? "" }
        case .titleDescending:
            mangas.sort { $0.title ?? "" > $1.title ?? "" }
        case .volumeAscending:
            mangas.sort { $0.totalOwnedVolumes < $1.totalOwnedVolumes }
        case .volumeDescending:
            mangas.sort { $0.totalOwnedVolumes > $1.totalOwnedVolumes }
        }
    }
    
    func addManga(title: String) {
        databaseService.addManga(title: title, ownedVolumes: 0, publicationStatus: 0, notes: "")
        fetchMangas()
    }
    
    func updateManga(_ manga: Manga, title: String, ownedVolumes: Int16, publicationStatus: Int16, notes: String) {
        databaseService.updateManga(manga, title: title, ownedVolumes: ownedVolumes, publicationStatus: publicationStatus, notes: notes)
        fetchMangas()
    }
    
    func deleteManga(manga: Manga) {
        databaseService.deleteManga(manga)
        fetchMangas()
    }
    
    // MARK: - MissingVolume
    
    func addMissingVolume(to manga: Manga, volumeNumber: Int16) {
        if databaseService.addMissingVolume(to: manga, volumeNumber: volumeNumber) {
            fetchMangas()
        } else {
            duplicateVolumeAlert = true
        }
    }
    
    func updateMissingVolume(manga: Manga, volume: MissingVolume, newVolumeNumber: Int16) {
        if databaseService.updateMissingVolume(manga: manga, volume: volume, newVolumeNumber: newVolumeNumber) {
            fetchMangas()
        } else {
            duplicateVolumeAlert = true
        }
    }
    
    func deleteMissingVolume(manga: Manga, volume: MissingVolume) {
        databaseService.deleteMissingVolume(manga: manga, volume: volume)
        fetchMangas()
    }
    
    // MARK: - OtherTitle
    
    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        databaseService.addOtherTitle(to: manga, title: title, ownedVolumes: ownedVolumes, notes: notes)
        fetchMangas() 
    }
    
    func updateOtherTitle(manga: Manga, otherTitle: OtherTitle, newTitle: String, newOwnedVolumes: Int16, newNotes: String) {
        databaseService.updateOtherTitle(otherTitle: otherTitle, newTitle: newTitle, newOwnedVolumes: newOwnedVolumes, newNotes: newNotes)
        fetchMangas()
    }
    
    func deleteOtherTitle(manga: Manga, otherTitle: OtherTitle) {
        databaseService.deleteOtherTitle(otherTitle: otherTitle)
        fetchMangas()
    }
    
    
    func countTitlesByStatus() -> [PublicationStatus: Int] {
        var countDict: [PublicationStatus: Int] = [:]
        for status in PublicationStatus.allCases {
            let count = mangas.filter { $0.publicationStatus == status.rawValue }.count
            countDict[status] = count
        }
        return countDict
    }

    func countVolumesByStatus() -> [PublicationStatus: Int] {
        var countDict: [PublicationStatus: Int] = [:]
        for status in PublicationStatus.allCases {
            let totalVolumes = mangas.filter { $0.publicationStatus == status.rawValue }
                                     .reduce(0) { $0 + Int($1.totalOwnedVolumes) }
            countDict[status] = totalVolumes
        }
        return countDict
    }
}
