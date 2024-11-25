//  AuthorService.swift

import Foundation
import CoreData

class AuthorService {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addAuthor(to manga: Manga, name: String) {
        let newAuthor = Author(context: context)
        newAuthor.name = name
        manga.addToAuthors(newAuthor)
        CoreDataService(context: context).saveContext()
    }

    func updateAuthor(_ author: Author, newName: String) {
        author.name = newName
        CoreDataService(context: context).saveContext()
    }

    func deleteAuthor(_ author: Author) {
        context.delete(author)
        CoreDataService(context: context).saveContext()
    }
}
