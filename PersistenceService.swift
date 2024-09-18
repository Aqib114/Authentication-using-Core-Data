import CoreData
import Foundation

class PersistenceService {

    // MARK: - Persistent Container
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Authentication_in_Swift") // Replace with your .xcdatamodeld filename
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    // MARK: - Context
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Context
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

