//  MangaService.swift

import Foundation
import CoreData

/// 漫画の編集内容をまとめた値
struct MangaDraft {
    var title: String
    var authors: [String]
    var ownedVolumes: Int
    var publicationStatus: PublicationStatus
    var notes: String
    var favorite: Bool
    var image: Data?
    var publisher: String
    var missingVolumes: [Int]

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValid: Bool {
        !trimmedTitle.isEmpty && ownedVolumes >= 0
    }
}

/// Core Data への読み書きをまとめたサービス
final class MangaService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Save

    @discardableResult
    func save() -> Bool {
        guard context.hasChanges else { return true }
        do {
            try context.save()
            return true
        } catch {
            print("Error saving context: \(error.localizedDescription)")
            context.rollback()
            return false
        }
    }

    // MARK: - Manga

    func fetchMangas() -> [Manga] {
        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching Manga: \(error.localizedDescription)")
            return []
        }
    }

    func addManga(title: String, publicationStatus: PublicationStatus, ownedVolumes: Int16, image: Data?) {
        let newManga = Manga(context: context)
        newManga.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        newManga.ownedVolumes = ownedVolumes
        newManga.totalOwnedVolumes = ownedVolumes
        newManga.publicationStatus = publicationStatus.rawValue
        newManga.publisher = defaultPublisher
        newManga.image = image
        newManga.order = (fetchMangas().map(\.order).max() ?? 0) + 1
        save()
    }

    func updateManga(_ manga: Manga, with draft: MangaDraft) -> Bool {
        guard draft.isValid else { return false }

        manga.title = draft.trimmedTitle
        manga.authorsArray = draft.authors
        manga.ownedVolumes = Int16(draft.ownedVolumes)
        manga.publicationStatus = draft.publicationStatus.rawValue
        manga.notes = draft.notes
        manga.favorite = draft.favorite
        manga.image = draft.image
        manga.publisher = draft.publisher
        // 最新巻より大きい不足巻は無効なので取り除く
        manga.missingVolumeNumbers = draft.missingVolumes.filter { $0 >= 1 && $0 <= draft.ownedVolumes }
        manga.updateTotalOwnedVolumes()
        return save()
    }

    func incrementOwnedVolumes(of manga: Manga) {
        guard manga.ownedVolumes < Int16.max else { return }
        manga.ownedVolumes += 1
        manga.updateTotalOwnedVolumes()
        save()
    }

    func deleteManga(_ manga: Manga) {
        context.delete(manga)
        normalizeOrders()
    }

    /// 並べ替え後の配列順で order を 1 から振り直す
    func reorder(_ mangas: [Manga]) {
        for (index, manga) in mangas.enumerated() {
            manga.order = Int16(index + 1)
        }
        save()
    }

    func normalizeOrders() {
        reorder(fetchMangas().filter { !$0.isDeleted })
    }

    // MARK: - OtherTitle

    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        let otherTitle = OtherTitle(context: context)
        otherTitle.title = title
        otherTitle.ownedVolumes = ownedVolumes
        otherTitle.notes = notes
        manga.addToOtherTitles(otherTitle)
        manga.updateTotalOwnedVolumes()
        save()
    }

    func updateOtherTitle(_ otherTitle: OtherTitle, title: String, ownedVolumes: Int16, notes: String) {
        otherTitle.title = title
        otherTitle.ownedVolumes = ownedVolumes
        otherTitle.notes = notes
        otherTitle.manga?.updateTotalOwnedVolumes()
        save()
    }

    func deleteOtherTitle(_ otherTitle: OtherTitle) {
        let manga = otherTitle.manga
        manga?.removeFromOtherTitles(otherTitle)
        context.delete(otherTitle)
        manga?.updateTotalOwnedVolumes()
        save()
    }
}
