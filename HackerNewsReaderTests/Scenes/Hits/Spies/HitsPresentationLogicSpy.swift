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

    var presentOlderHitsGotCalled = false
    var presentOlderHitsResponse: Hits.FetchHits.Response?
    func presentOlderHits(response: Hits.FetchHits.Response) {
        presentOlderHitsGotCalled = true
        presentOlderHitsResponse = response
    }

    var presentHitGotCalled = false
    func presentHit() {
        presentHitGotCalled = true
    }

    var deleteHitGotCalled = false
    var deleteHitResponse: Hits.Delete.Response?
    func deleteHit(response: Hits.Delete.Response) {
        deleteHitGotCalled = true
        deleteHitResponse = response
    }

    var cantNavigateToURLGotCalled = false
    var cantNavigateToURLResponse: Hits.NoShow.Response?
    func cantNavigateToURL(response: Hits.NoShow.Response) {
        cantNavigateToURLGotCalled = true
        cantNavigateToURLResponse = response
    }
}
