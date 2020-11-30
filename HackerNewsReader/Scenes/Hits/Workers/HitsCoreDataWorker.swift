//
//  HitsCoreDataWorker.swift
//  HackerNewsReader
//
//  Created by Iván on 28-11-20.
//

import CoreData

class HitsCoreDataWorker {

    func fetchHits(offset: Int = 0,
                   persistenceController: PersistenceController = PersistenceController.shared,
                   block: @escaping ([Hits.HitPresentationModel]?, Error?) -> Void) {

        let feedService = FeedService(persistenceController: persistenceController)

        feedService.feed(offset: offset) { hits in
            var hitsPresentation: [Hits.HitPresentationModel] = []

            for hit in hits {
                let hitPresentation = Hits.HitPresentationModel(
                    title: hit.title != nil ? hit.title! : hit.storyTitle ?? "",
                    author: hit.author ?? "No author",
                    createdAt: hit.createdAt ?? Date(),
                    url: hit.url != nil ? hit.url! : hit.storyURL ?? "")

                hitsPresentation.append(hitPresentation)
            }
            block(hitsPresentation, nil)
        }
    }

    func  deleteHit(url: String,
                    persistenceController: PersistenceController = PersistenceController.shared,
                    block: @escaping () -> Void) {

        let fetchRequest: NSFetchRequest<Hit> = Hit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@ || storyURL == %@", url, url)

        persistenceController.container.viewContext.perform {
            do {
                let results = try persistenceController.container.viewContext.fetch(fetchRequest)
                results.first?.isUserDeleted = true
                do {
                    try persistenceController.container.viewContext.save()
                } catch {
                    debugPrint(error)
                }
                block()

            } catch let error as NSError {
                debugPrint("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
    }
}
