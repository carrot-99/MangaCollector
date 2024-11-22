//  DatabaseService.swift

import Foundation
import CoreData

class DatabaseService {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Manga
    
    func fetchMangas(completion: @escaping ([Manga]?) -> Void) {
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()

        do {
            var mangas = try context.fetch(request)
            
            // orderが未設定または不整合の場合に修正
            let needsRecalculation = mangas.contains { $0.order == 0 }
            if needsRecalculation {
                mangas.enumerated().forEach { index, manga in
                    manga.order = Int16(index)
                }
                saveContext() // CoreDataに保存
            }

            // 並び替えして返す
            mangas.sort { $0.order < $1.order }
            completion(mangas)
        } catch {
            print("Error fetching Manga: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func fetchAllMangas() -> [Manga]? {
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching all Manga: \(error.localizedDescription)")
            return nil
        }
    }

    func addManga(title: String, publicationStatus: Int16, ownedVolumes: Int16, image: Data?) {
        let newManga = Manga(context: context)
        newManga.title = title
        newManga.ownedVolumes = ownedVolumes
        newManga.totalOwnedVolumes = ownedVolumes
        newManga.publicationStatus = publicationStatus
        newManga.publisher = "選択なし"
        newManga.image = image
        
        // orderを初期化する（既存のオブジェクト数 + 1）
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        do {
            let existingMangas = try context.fetch(request)
            newManga.order = Int16(existingMangas.count)
        } catch {
            print("Error initializing order: \(error.localizedDescription)")
            newManga.order = 0 // デフォルト値
        }
        
        saveContext()  // CoreDataのコンテキストを保存
    }

    func updateManga(_ manga: Manga, title: String, authors: [String], ownedVolumes: Int16, publicationStatus: Int16, notes: String, favorite: Bool, image: Data?, publisher: String, totalOwnedVolumes: Int16) -> Bool {
        guard !title.isEmpty, ownedVolumes >= 0 else {
            return false
        }

        manga.title = title
        manga.authorsArray = authors
        manga.ownedVolumes = ownedVolumes
        manga.publicationStatus = publicationStatus
        manga.notes = notes
        manga.favorite = favorite
        manga.image = image
        manga.publisher = publisher
        manga.totalOwnedVolumes = totalOwnedVolumes

        do {
            try context.save()
            return true
        } catch {
            print("Error updating manga: \(error.localizedDescription)")
            return false
        }
    }


    func deleteManga(_ manga: Manga) {
        context.delete(manga)
        saveContext()
        recalculateOrders()
    }
    
    private func recalculateOrders() {
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)] // 確実に order 順で取得する

        do {
            let mangas = try context.fetch(request)
            for (index, manga) in mangas.enumerated() {
                manga.order = Int16(index + 1) // 1から始まる順序を付与
            }
            saveContext() // 更新後に保存
        } catch {
            print("Error recalculating orders: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Author
    
    func addAuthor(to manga: Manga, name: String) {
        let newAuthor = Author(context: context)
        newAuthor.name = name
         manga.addToAuthors(newAuthor)
         saveContext()
    }
    
    func updateAuthor(_ author: Author, newName: String) {
        author.name = newName
        saveContext()
    }
    
    func deleteAuthor(_ author: Author) {
        context.delete(author)
        saveContext()
    }

    // MARK: - MissingVolume
    
    func addMissingVolume(to manga: Manga, volumeNumber: Int16) -> Bool {
        if !isVolumeNumberExists(in: manga, volumeNumber: volumeNumber) {
            let missingVolume = MissingVolume(context: context)
            missingVolume.volumeNumber = volumeNumber
            manga.addToMissingVolumes(missingVolume)
            saveContext()
            return true
        }
        return false
    }
    
    func updateMissingVolume(manga: Manga, volume: MissingVolume, newVolumeNumber: Int16) -> Bool {
        if !isVolumeNumberExists(in: manga, volumeNumber: newVolumeNumber, excluding: volume) {
            volume.volumeNumber = newVolumeNumber
            saveContext()
            return true
        }
        return false
    }
    
    func deleteMissingVolume(manga: Manga, volume: MissingVolume) {
        context.delete(volume)
        saveContext()
    }
    
    private func isVolumeNumberExists(in manga: Manga, volumeNumber: Int16, excluding excludedVolume: MissingVolume? = nil) -> Bool {
        let existingVolumes = manga.missingVolumes?.allObjects as? [MissingVolume] ?? []
        return existingVolumes.contains { volume in
            return volume !== excludedVolume && volume.volumeNumber == volumeNumber
        }
    }

    // MARK: - OtherTitle
    
    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        let otherTitle = OtherTitle(context: context)
        otherTitle.title = title
        otherTitle.ownedVolumes = ownedVolumes
        otherTitle.notes = notes
        manga.addToOtherTitles(otherTitle)

        saveContext()
    }
    
    func updateOtherTitle(otherTitle: OtherTitle, newTitle: String, newOwnedVolumes: Int16, newNotes: String) {
        otherTitle.title = newTitle
        otherTitle.ownedVolumes = newOwnedVolumes
        otherTitle.notes = newNotes
        saveContext()
    }
    
    func deleteOtherTitle(otherTitle: OtherTitle) {
        context.delete(otherTitle)
        saveContext()
    }
}
