//
//  Persistence.swift
//  Shift Splitter
//
//  Created by Iván on 03-11-20.
//

import CoreData

final class PersistenceController {
    static let shared: PersistenceController = {
        if let _ = ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] {
            return PersistenceController(inMemory: true)
        } else {
            return PersistenceController()
        }
    }()

    private(set) var container: NSPersistentCloudKitContainer?

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "HackerNewsReader")
        if inMemory {
            container?.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container?.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                debugPrint("Unresolved error \(error), \(error.userInfo)")
            } else {
                debugPrint("\n  STORES LOADED! \(storeDescription) \n")
            }

            self.container?.viewContext.automaticallyMergesChangesFromParent = true
            self.container?.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

        })
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        if let context = PersistenceController.shared.container?.viewContext,
           context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func clearContainer() {
        container = nil
    }
}

extension NSManagedObjectContext {

    /// Only performs a save if there are changes to commit.
    /// - Returns: `true` if a save was needed. Otherwise, `false`.
    @discardableResult public func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}
