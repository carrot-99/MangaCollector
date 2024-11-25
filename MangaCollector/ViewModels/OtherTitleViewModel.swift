//  OtherTitleViewModel.swift

import Foundation

class OtherTitleViewModel {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func addOtherTitle(to manga: Manga, title: String, ownedVolumes: Int16, notes: String) {
        databaseService.addOtherTitle(to: manga, title: title, ownedVolumes: ownedVolumes, notes: notes)
    }

    func updateOtherTitle(manga: Manga, otherTitle: OtherTitle, newTitle: String, newOwnedVolumes: Int16, newNotes: String) {
        databaseService.updateOtherTitle(otherTitle: otherTitle, newTitle: newTitle, newOwnedVolumes: newOwnedVolumes, newNotes: newNotes)
    }

    func deleteOtherTitle(manga: Manga, otherTitle: OtherTitle) {
        databaseService.deleteOtherTitle(otherTitle: otherTitle)
    }
}
