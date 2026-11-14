//  MangaCollectorApp.swift

import SwiftUI
import CoreData

@main
struct MangaCollectorApp: App {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MangaCollector")
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            let context = container.viewContext
            initializeOrderIfNeeded(context: context)
            migrateMissingVolumesIfNeeded(context: context)
        }
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistentContainer.viewContext)
        }
    }

    /// order 未設定（0）の作品があれば 1 から振り直す
    private static func initializeOrderIfNeeded(context: NSManagedObjectContext) {
        let service = MangaService(context: context)
        if service.fetchMangas().contains(where: { $0.order == 0 }) {
            service.normalizeOrders()
        }
    }

    /// `MissingVolume` エンティティのデータを `Manga.missingVolumesList` に移行する
    private static func migrateMissingVolumesIfNeeded(context: NSManagedObjectContext) {
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKey.missingVolumesMigrationDone) else { return }

        let request: NSFetchRequest<Manga> = Manga.fetchRequest()
        do {
            for manga in try context.fetch(request) {
                if let missingVolumes = manga.missingVolumes as? Set<MissingVolume>, !missingVolumes.isEmpty {
                    let migrated = missingVolumes.map { Int($0.volumeNumber) }
                    manga.missingVolumeNumbers = manga.missingVolumeNumbers + migrated
                }
                // 旧ロジックで保存された総数を新しい計算式で補正する
                manga.updateTotalOwnedVolumes()
            }
            if context.hasChanges {
                try context.save()
            }
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.missingVolumesMigrationDone)
        } catch {
            print("Error migrating missing volumes: \(error.localizedDescription)")
        }
    }
}
