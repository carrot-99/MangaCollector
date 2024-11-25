//  MissingVolumeViewModel.swift

import Foundation

class MissingVolumeViewModel {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func addMissingVolume(to manga: Manga, volumeNumber: Int16) -> Bool {
        return databaseService.addMissingVolume(to: manga, volumeNumber: volumeNumber)
    }

    func updateMissingVolume(manga: Manga, volume: MissingVolume, newVolumeNumber: Int16) -> Bool {
        return databaseService.updateMissingVolume(manga: manga, volume: volume, newVolumeNumber: newVolumeNumber)
    }

    func deleteMissingVolume(manga: Manga, volume: MissingVolume) {
        databaseService.deleteMissingVolume(manga: manga, volume: volume)
    }
}
