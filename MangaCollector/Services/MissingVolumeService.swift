//  MissingVolumeService.swift

import Foundation
import CoreData

class MissingVolumeService {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addMissingVolume(to manga: Manga, volumeNumber: Int16) -> Bool {
        if !isVolumeNumberExists(in: manga, volumeNumber: volumeNumber) {
            let missingVolume = MissingVolume(context: context)
            missingVolume.volumeNumber = volumeNumber
            manga.addToMissingVolumes(missingVolume)
            CoreDataService(context: context).saveContext()
            return true
        }
        return false
    }

    func updateMissingVolume(manga: Manga, volume: MissingVolume, newVolumeNumber: Int16) -> Bool {
        if !isVolumeNumberExists(in: manga, volumeNumber: newVolumeNumber, excluding: volume) {
            volume.volumeNumber = newVolumeNumber
            CoreDataService(context: context).saveContext()
            return true
        }
        return false
    }

    func deleteMissingVolume(manga: Manga, volume: MissingVolume) {
        context.delete(volume)
        CoreDataService(context: context).saveContext()
    }

    private func isVolumeNumberExists(in manga: Manga, volumeNumber: Int16, excluding excludedVolume: MissingVolume? = nil) -> Bool {
        let existingVolumes = manga.missingVolumes?.allObjects as? [MissingVolume] ?? []
        return existingVolumes.contains { volume in
            return volume !== excludedVolume && volume.volumeNumber == volumeNumber
        }
    }
}
