//
//  Seeds.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 28-11-20.
//

import Foundation
import XCTest
@testable import HackerNewsReader

struct Seeds {
    private init() {}
}

extension Seeds {
    struct HitSamples {
        private init() {}

        static func hits(persistenceController: PersistenceController) -> [Hit] {
            return [hitOne(persistenceController: persistenceController), hitTwo(persistenceController: persistenceController)]
        }

        static func hitOne(persistenceController: PersistenceController) -> Hit {
            let hit = Hit(context: persistenceController.container!.viewContext)
            hit.title = "Test 1"
            hit.id = "25224216"
            try? persistenceController.container!.viewContext.save()
            return hit
        }

        static func hitTwo(persistenceController: PersistenceController) -> Hit {

            let hit = Hit(context: persistenceController.container!.viewContext)
            hit.title = "Test 2"
            hit.id = "25224210"
            try? persistenceController.container!.viewContext.save()
            return hit
        }

        static let hitDTOOne = HitDTO(author: "Author 1",
                                      storyTitle: nil,
                                      title: "Title 1",
                                      createdAt: Date(),
                                      objectID: "1",
                                      url: "https://usefathom.com/blog/ddos-attack",
                                      storyURL: nil)
        static let hitDTOTwo = HitDTO(author: "Author 2",
                                      storyTitle: "Story Title 2",
                                      title: nil,
                                      createdAt: Date(),
                                      objectID: "2",
                                      url: nil,
                                      storyURL: "http://localhost/story/2")
        static let hitsDTO = [hitDTOOne, hitDTOTwo]

        static let hitPresentationOne = Hits.HitPresentationModel(title: "Title 1", author: "Author 1", createdAt: Date(), url: "URL1")
        static let hitPresentationTwo = Hits.HitPresentationModel(title: "Title 2", author: "Author 2", createdAt: Date(), url: "URL2")

        static let hitsPresentation = [hitPresentationOne, hitPresentationTwo]

        static let hitVMOne: Hits.HitViewModel = Hits.HitViewModel(title: "Test 1", subTitle: "Subtitle 1", url: "http://URL1")
        static let hitVMTwo: Hits.HitViewModel = Hits.HitViewModel(title: "Test 2", subTitle: "Subtitle 2", url: "http://URL2")

        static let hitsVM = [hitVMOne, hitVMTwo]
    }
}
