//  CoreDataService.swift

import Foundation
import CoreData

class CoreDataService {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
}
