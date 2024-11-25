//  AuthorViewModel.swift

import Foundation

class AuthorViewModel {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func addAuthor(to manga: Manga, name: String) {
        databaseService.addAuthor(to: manga, name: name)
    }

    func updateAuthor(_ author: Author, newName: String) {
        databaseService.updateAuthor(author, newName: newName)
    }

    func deleteAuthor(_ author: Author) {
        databaseService.deleteAuthor(author)
    }
}
