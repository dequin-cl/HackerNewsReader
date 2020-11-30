//
//  FeedService.swift
//  HackerNewsReader
//
//  Created by Iván on 27-11-20.
//

import Foundation
import CoreData

final class FeedService {
    // MARK: - Properties
    let persistenceController: PersistenceController

    // MARK: - Initializers
    public init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
}

extension FeedService {

    /// Creates a Hit on the Core Data
    /// - Parameter hitDTO: Hit Data Transfer Object
    /// - Parameter block: Delivers a Hit Core Data Managed Object
    func add(_ hitDTO: HitDTO, _ block: @escaping (Hit) -> Void) {

        persistenceController.container.performBackgroundTask { (backgroundContext) in
            let hit = Hit.from(hitDTO, in: backgroundContext)

            backgroundContext.perform {
                do {
                    try backgroundContext.save()
                } catch { }
                block(hit)
            }
        }
    }

    /// List the hits on Core Data
    /// - Parameter block: Delivers a list of Hits Core Data Managed Object
    func feed(limit: Int = 20, offset: Int = 0, _ block: @escaping ([Hit]) -> Void) {
        let fetchRequest: NSFetchRequest<Hit> = Hit.fetchRequest()
        fetchRequest.propertiesToFetch = ["author", "createdAt", "storyTitle", "storyURL", "title", "url"]
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset

        persistenceController.container.performBackgroundTask { (backgroundContext) in
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                block(results)
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
                block([])
            }
        }
    }

    /// Receives a list of Data Transfer Objects with Hits information and adds them to the Database as Hits objects
    /// - Parameter hitsDTO: list of hits from the API
    func process(_ hitsDTO: [HitDTO], block: @escaping () -> Void = {}) {

        persistenceController.container.performBackgroundTask { (backgroundContext) in

            backgroundContext.perform {

                for hitDTO in hitsDTO {
                    _ = Hit.from(hitDTO, in: backgroundContext)

                    do {
                        try backgroundContext.save()
                    } catch {
                        debugPrint("\(hitDTO.title ?? "") \(hitDTO.storyTitle ?? "")")
                    }
                }

                DispatchQueue.main.async {
                    block()
                }
            }
        }
    }
}
