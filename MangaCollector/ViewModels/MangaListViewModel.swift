//  MangaListViewModel.swift

import Foundation
import CoreData

class MangaListViewModel: ObservableObject {
    @Published var mangas: [Manga] = []
    @Published var sortOption: SortOption = .defaultOrder
    @Published var duplicateVolumeAlert = false

    private let mangaViewModel: MangaViewModel
    private let authorViewModel: AuthorViewModel
    private let missingVolumeViewModel: MissingVolumeViewModel
    private let otherTitleViewModel: OtherTitleViewModel
    private let graphViewModel: GraphViewModel

    init(context: NSManagedObjectContext) {
        let databaseService = DatabaseService(context: context)
        self.mangaViewModel = MangaViewModel(databaseService: databaseService)
        self.authorViewModel = AuthorViewModel(databaseService: databaseService)
        self.missingVolumeViewModel = MissingVolumeViewModel(databaseService: databaseService)
        self.otherTitleViewModel = OtherTitleViewModel(databaseService: databaseService)
        self.graphViewModel = GraphViewModel(databaseService: databaseService)

        fetchMangas()
        sortMangas()
    }

    // Manga関連処理の委譲
    func fetchMangas() {
        mangas = mangaViewModel.fetchMangas()
    }

    func sortMangas() {
        mangas = mangaViewModel.sortMangas(mangas: mangas, by: sortOption)
    }

    func addManga(title: String, publicationStatus: Int16, ownedVolumes: Int16, image: Data?) {
        mangaViewModel.addManga(title: title, publicationStatus: publicationStatus, ownedVolumes: ownedVolumes, image: image)
        fetchMangas()
    }

    func updateManga(_ manga: Manga, title: String, authors: [String], ownedVolumes: Int16, publicationStatus: Int16, notes: String, favorite: Bool, image: Data?, publisher: String, totalOwnedVolumes: Int16) -> Bool {
        let result = mangaViewModel.updateManga(manga, title: title, authors: authors, ownedVolumes: ownedVolumes, publicationStatus: publicationStatus, notes: notes, favorite: favorite, image: image, publisher: publisher, totalOwnedVolumes: totalOwnedVolumes)
        fetchMangas()
        return result
    }

    func deleteManga(_ manga: Manga) {
        mangaViewModel.deleteManga(manga)
        fetchMangas()
    }

    func updateOrder(for manga: Manga, newOrder: Int16) {
        mangaViewModel.updateOrder(for: manga, newOrder: newOrder)
        fetchMangas()
    }

    // Author関連処理の委譲
    func addAuthor(to manga: Manga, name: String) {
        authorViewModel.addAuthor(to: manga, name: name)
        fetchMangas()
    }

    func updateAuthor(author: Author, newName: String) {
        authorViewModel.updateAuthor(author, newName: newName)
        fetchMangas()
    }

    func deleteAuthor(author: Author) {
        authorViewModel.deleteAuthor(author)
        fetchMangas()
    }

    // MissingVolume関連処理の委譲
    func addMissingVolume(to manga: Manga, volumeNumber: Int16) -> Bool {
        let success = missingVolumeViewModel.addMissingVolume(to: manga, volumeNumber: volumeNumber)
        if !success {
            duplicateVolumeAlert = true
        }
        fetchMangas()
        return success
    }

    func updateMissingVolume(manga: Manga, volume: MissingVolume, newVolumeNumber: Int16) -> Bool {
        let success = missingVolumeViewModel.updateMissingVolume(manga: manga, volume: volume, newVolumeNumber: newVolumeNumber)
        if !success {
            duplicateVolumeAlert = true
        }
        fetchMangas()
        return success
    }

    func deleteMissingVolume(manga: Manga, volume: MissingVolume) {
        missingVolumeViewModel.deleteMissingVolume(manga: manga, volume: volume)
        fetchMangas()
    }

    // OtherTitle関連処理の委譲
    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        otherTitleViewModel.addOtherTitle(to: manga, title: title, ownedVolumes: ownedVolumes, notes: notes)
        fetchMangas()
    }

    func updateOtherTitle(manga: Manga, otherTitle: OtherTitle, newTitle: String, newOwnedVolumes: Int16, newNotes: String) {
        otherTitleViewModel.updateOtherTitle(manga: manga, otherTitle: otherTitle, newTitle: newTitle, newOwnedVolumes: newOwnedVolumes, newNotes: newNotes)
        fetchMangas()
    }

    func deleteOtherTitle(manga: Manga, otherTitle: OtherTitle) {
        otherTitleViewModel.deleteOtherTitle(manga: manga, otherTitle: otherTitle)
        fetchMangas()
    }

    // Graph関連処理の委譲
    func countTitlesByStatus() -> [PublicationStatus: Int] {
        return graphViewModel.countTitlesByStatus(mangas: mangas)
    }

    func countVolumesByStatus() -> [PublicationStatus: Int] {
        return graphViewModel.countVolumesByStatus(mangas: mangas)
    }
}
