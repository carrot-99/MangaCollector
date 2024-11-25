//  OtherTitleService.swift

import Foundation
import CoreData

class OtherTitleService {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        let otherTitle = OtherTitle(context: context)
        otherTitle.title = title
        otherTitle.ownedVolumes = ownedVolumes
        otherTitle.notes = notes
        manga.addToOtherTitles(otherTitle)
        CoreDataService(context: context).saveContext()
    }

    func updateOtherTitle(otherTitle: OtherTitle, newTitle: String, newOwnedVolumes: Int16, newNotes: String) {
        otherTitle.title = newTitle
        otherTitle.ownedVolumes = newOwnedVolumes
        otherTitle.notes = newNotes
        CoreDataService(context: context).saveContext()
    }

    func deleteOtherTitle(otherTitle: OtherTitle) {
        context.delete(otherTitle)
        CoreDataService(context: context).saveContext()
    }
}
