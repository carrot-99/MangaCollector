//  DatabaseService.swift

import Foundation
import CoreData

class DatabaseService {
    private var coreDataService: CoreDataService
    private var mangaService: MangaService
    private var authorService: AuthorService
    private var missingVolumeService: MissingVolumeService
    private var otherTitleService: OtherTitleService

    init(context: NSManagedObjectContext) {
        self.coreDataService = CoreDataService(context: context)
        self.mangaService = MangaService(context: context)
        self.authorService = AuthorService(context: context)
        self.missingVolumeService = MissingVolumeService(context: context)
        self.otherTitleService = OtherTitleService(context: context)
    }

    // MARK: - CoreData

    func saveContext() {
        coreDataService.saveContext()
    }

    // MARK: - Manga

    func fetchMangas(completion: @escaping ([Manga]?) -> Void) {
        mangaService.fetchMangas(completion: completion)
    }

    func fetchAllMangas() -> [Manga]? {
        mangaService.fetchAllMangas()
    }

    func addManga(title: String, publicationStatus: Int16, ownedVolumes: Int16, image: Data?) {
        mangaService.addManga(title: title, publicationStatus: publicationStatus, ownedVolumes: ownedVolumes, image: image)
    }

    func updateManga(
        _ manga: Manga,
        title: String,
        authors: [String],
        ownedVolumes: Int16,
        publicationStatus: Int16,
        notes: String,
        favorite: Bool,
        image: Data?,
        publisher: String,
        totalOwnedVolumes: Int16
    ) -> Bool {
        return mangaService.updateManga(
            manga,
            title: title,
            authors: authors,
            ownedVolumes: ownedVolumes,
            publicationStatus: publicationStatus,
            notes: notes,
            favorite: favorite,
            image: image,
            publisher: publisher,
            totalOwnedVolumes: totalOwnedVolumes
        )
    }

    func deleteManga(_ manga: Manga) {
        mangaService.deleteManga(manga)
    }

    // MARK: - Author

    func addAuthor(to manga: Manga, name: String) {
        authorService.addAuthor(to: manga, name: name)
    }

    func updateAuthor(_ author: Author, newName: String) {
        authorService.updateAuthor(author, newName: newName)
    }

    func deleteAuthor(_ author: Author) {
        authorService.deleteAuthor(author)
    }

    // MARK: - MissingVolume

    func addMissingVolume(to manga: Manga, volumeNumber: Int16) -> Bool {
        return missingVolumeService.addMissingVolume(to: manga, volumeNumber: volumeNumber)
    }

    func updateMissingVolume(manga: Manga, volume: MissingVolume, newVolumeNumber: Int16) -> Bool {
        return missingVolumeService.updateMissingVolume(manga: manga, volume: volume, newVolumeNumber: newVolumeNumber)
    }

    func deleteMissingVolume(manga: Manga, volume: MissingVolume) {
        missingVolumeService.deleteMissingVolume(manga: manga, volume: volume)
    }

    // MARK: - OtherTitle

    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        otherTitleService.addOtherTitle(to: manga, title: title, ownedVolumes: ownedVolumes, notes: notes)
    }

    func updateOtherTitle(otherTitle: OtherTitle, newTitle: String, newOwnedVolumes: Int16, newNotes: String) {
        otherTitleService.updateOtherTitle(otherTitle: otherTitle, newTitle: newTitle, newOwnedVolumes: newOwnedVolumes, newNotes: newNotes)
    }

    func deleteOtherTitle(otherTitle: OtherTitle) {
        otherTitleService.deleteOtherTitle(otherTitle: otherTitle)
    }
}
