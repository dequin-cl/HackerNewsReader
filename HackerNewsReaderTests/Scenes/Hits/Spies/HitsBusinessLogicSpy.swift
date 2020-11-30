//
//  HitsBusinessLogicSpy.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader

class HitsBusinessLogicSpy: HitsBusinessLogic {
    var grabHitsGotCalled = false
    func grabHits() {
        grabHitsGotCalled = true
    }

    var grabOlderHitsGotCalled = false
    var grabOlderHitsRequest: Hits.FetchHits.Request?
    func grabOlderHits(request: Hits.FetchHits.Request) {
        grabOlderHitsGotCalled = true
        grabOlderHitsRequest = request
    }

    var selectHitGotCalled = false
    var selectHitRequest: Hits.Show.Request?
    func selectHit(request: Hits.Show.Request) {
        selectHitGotCalled = true
        selectHitRequest = request
    }
}
