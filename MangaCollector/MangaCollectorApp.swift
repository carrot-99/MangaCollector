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
        }
        return container
    }()


    var body: some Scene {
        WindowGroup {
            ContentView(context: persistentContainer.viewContext)
        }
    }
}
