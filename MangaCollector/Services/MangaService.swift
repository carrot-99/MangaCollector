//  MangaService.swift

import Foundation
import CoreData

class MangaService {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchMangas(completion: @escaping ([Manga]?) -> Void) {
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        do {
            var mangas = try context.fetch(request)
            let needsRecalculation = mangas.contains { $0.order == 0 }
            if needsRecalculation {
                mangas.enumerated().forEach { index, manga in
                    manga.order = Int16(index)
                }
                CoreDataService(context: context).saveContext()
            }
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

        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        do {
            let existingMangas = try context.fetch(request)
            newManga.order = Int16(existingMangas.count)
        } catch {
            newManga.order = 0
        }

        CoreDataService(context: context).saveContext()
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
        guard !title.isEmpty, ownedVolumes >= 0 else { return false }

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
        CoreDataService(context: context).saveContext()
        recalculateOrders()
    }

    private func recalculateOrders() {
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            let mangas = try context.fetch(request)
            for (index, manga) in mangas.enumerated() {
                manga.order = Int16(index + 1)
            }
            CoreDataService(context: context).saveContext()
        } catch {
            print("Error recalculating orders: \(error.localizedDescription)")
        }
    }
}
