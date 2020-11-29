//
//  HitsCoreDataWorker.swift
//  HackerNewsReader
//
//  Created by Iván on 28-11-20.
//

import CoreData

class HitsCoreDataWorker {

    func fetchHits(persistenceController: PersistenceController = PersistenceController.shared,
                   block: @escaping ([Hit]?, Error?) -> Void) {

        let feedService = FeedService(persistenceController: persistenceController)

        feedService.feed { hits in
            block(hits, nil)
        }
    }
}
