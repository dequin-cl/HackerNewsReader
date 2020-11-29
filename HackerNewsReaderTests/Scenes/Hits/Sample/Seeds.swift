//
//  Seeds.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 28-11-20.
//

import Foundation
@testable import HackerNewsReader

struct Seeds {
    private init() {}
}

extension Seeds {
    struct HitSamples {
        private init() {}

        private static let context = PersistenceController.shared.container.viewContext
        static var hitOne: Hit = {
            let hit = Hit(context: context)
            hit.title = "Test 1"
            hit.id = "25224216"
            try? context.save()
            return hit
        }()
        static var hitTwo: Hit = {
            let hit = Hit(context: context)
            hit.title = "Test 2"
            hit.id = "25224210"
            try? context.save()
            return hit
        }()

        static let hits = [hitOne, hitTwo]

        static let hitDTOOne = HitDTO(author: "Author 1",
                                      storyTitle: nil,
                                      title: "Title 1",
                                      createdAt: Date(),
                                      objectID: "1",
                                      url: "http://localhost/1",
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

        static let hitVMOne: Hits.HitViewModel = Hits.HitViewModel(title: "Test 1", subTitle: "Subtitle 1")
        static let hitVMTwo: Hits.HitViewModel = Hits.HitViewModel(title: "Test 2", subTitle: "Subtitle 2")

        static let hitsVM = [hitVMOne, hitVMTwo]
    }
}
