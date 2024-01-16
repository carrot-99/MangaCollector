//  MangaCollectorApp.swift

import SwiftUI
import CoreData

@main
struct MangaCollectorApp: App {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MangaCollector")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
