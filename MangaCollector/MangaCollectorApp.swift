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
            
            // order属性を初期化（既存データに対する一括処理）
            let context = container.viewContext
            let request: NSFetchRequest<Manga> = Manga.fetchRequest()
            do {
                let mangas = try context.fetch(request)
                for (index, manga) in mangas.enumerated() {
                    if manga.order == 0 { // 未初期化
                        manga.order = Int16(index + 1)
                    }
                }
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Error initializing order for existing data: \(error.localizedDescription)")
            }
            
            // Authorエンティティ撤廃後移行
            migrateAuthorDataIfNeeded(context: context)
        }
        return container
    }()


    var body: some Scene {
        WindowGroup {
            ContentView(context: persistentContainer.viewContext)
        }
    }
    
    /// `Author`データを`Manga`の`authors`属性に移行する
    static func migrateAuthorDataIfNeeded(context: NSManagedObjectContext) {
        let migrationKey = "isAuthorMigrationDone"
        let isMigrationDone = UserDefaults.standard.bool(forKey: migrationKey)

        guard !isMigrationDone else { return } // 既に移行済みならスキップ

        let mangaRequest: NSFetchRequest<Manga> = Manga.fetchRequest()
        do {
            let mangas = try context.fetch(mangaRequest)
            for manga in mangas {
                if let authorsSet = manga.authors as? Set<Author> {
                    let authorNames = authorsSet.compactMap { $0.name }
                    manga.authorsArray = authorNames // `Transformable`プロパティに設定
                }
            }

            if context.hasChanges {
                try context.save() // 変更を保存
                UserDefaults.standard.set(true, forKey: migrationKey) // フラグを更新
            }
        } catch {
            print("Error migrating authors: \(error.localizedDescription)")
        }
    }
}
