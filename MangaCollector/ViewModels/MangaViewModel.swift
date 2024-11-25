//  MangaViewModel.swift

import Foundation

class MangaViewModel {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func fetchMangas() -> [Manga] {
        var result: [Manga] = []
        databaseService.fetchMangas { mangas in
            if let mangas = mangas {
                result = mangas
            }
        }
        return result
    }

    func sortMangas(mangas: [Manga], by option: SortOption) -> [Manga] {
        switch option {
        case .defaultOrder:
            return mangas.sorted { $0.order < $1.order }
        case .titleAscending:
            return mangas.sorted { $0.title ?? "" < $1.title ?? "" }
        case .titleDescending:
            return mangas.sorted { $0.title ?? "" > $1.title ?? "" }
        case .volumeAscending:
            return mangas.sorted { $0.totalOwnedVolumes < $1.totalOwnedVolumes }
        case .volumeDescending:
            return mangas.sorted { $0.totalOwnedVolumes > $1.totalOwnedVolumes }
        }
    }

    func addManga(title: String, publicationStatus: Int16, ownedVolumes: Int16, image: Data?) {
        databaseService.addManga(title: title, publicationStatus: publicationStatus, ownedVolumes: ownedVolumes, image: image)
    }

    func updateManga(_ manga: Manga, title: String, authors: [String], ownedVolumes: Int16, publicationStatus: Int16, notes: String, favorite: Bool, image: Data?, publisher: String, totalOwnedVolumes: Int16) -> Bool {
        return databaseService.updateManga(manga, title: title, authors: authors, ownedVolumes: ownedVolumes, publicationStatus: publicationStatus, notes: notes, favorite: favorite, image: image, publisher: publisher, totalOwnedVolumes: totalOwnedVolumes)
    }

    func deleteManga(_ manga: Manga) {
        databaseService.deleteManga(manga)
    }

    func updateOrder(for manga: Manga, newOrder: Int16) {
        manga.order = newOrder
        databaseService.saveContext()
    }
}
