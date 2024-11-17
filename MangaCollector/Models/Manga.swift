//  Manga.swift

import Foundation

extension Manga {
    var missingVolumesArray: [MissingVolume] {
        let set = missingVolumes as? Set<MissingVolume> ?? []
        return set.sorted { $0.volumeNumber < $1.volumeNumber }
    }
    
    var missingVolumesString: String {
        let volumes = (missingVolumes as? Set<MissingVolume> ?? []).map { $0.volumeNumber }
        let sortedVolumes = volumes.sorted()
        return sortedVolumes.map { String($0) }.joined(separator: ", ")
    }
    
    var otherTitlesArray: [OtherTitle] {
        let set = otherTitles as? Set<OtherTitle> ?? []
        return set.sorted { $0.title ?? "" < $1.title ?? "" }
    }
    
    var calculatedOwnedVolumes: Int {
        let missingVolumeCount = (self.missingVolumes as? Set<MissingVolume>)?.count ?? 1
        let otherTitlesOwnedVolumesTotal = otherTitlesArray.reduce(0) { total, otherTitle in
            total + Int(otherTitle.ownedVolumes)
        }
        return Int(self.ownedVolumes) + otherTitlesOwnedVolumesTotal - missingVolumeCount
    }
    
    func updateTotalOwnedVolumes() {
        self.totalOwnedVolumes = Int16(self.calculatedOwnedVolumes)
    }
}
