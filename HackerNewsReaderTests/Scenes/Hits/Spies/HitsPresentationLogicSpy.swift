//
//  HitsPresentationLogicSpy.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader

class HitsPresentationLogicSpy: HitsPresentationLogic {
    var presentHitsGotCalled = false
    var presentHitsResponse: Hits.FetchHits.Response?
    func presentHits(response: Hits.FetchHits.Response) {
        presentHitsGotCalled = true
        presentHitsResponse = response
    }
}
