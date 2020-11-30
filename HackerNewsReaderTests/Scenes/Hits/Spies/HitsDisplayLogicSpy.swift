//
//  HitsDisplayLogicSpy.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader

class HitsDisplayLogicSpy: HitsDisplayLogic {

    var displayHitsViewModel: Hits.FetchHits.ViewModel?
    var displayHitsGotCalled = false
    func displayHits(viewModel: Hits.FetchHits.ViewModel) {
        displayHitsGotCalled = true
        displayHitsViewModel = viewModel
    }

    var displayOlderHitsViewModel: Hits.FetchHits.ViewModel?
    var displayOlderHitsGotCalled = false
    func displayOlderHits(viewModel: Hits.FetchHits.ViewModel) {
        displayOlderHitsGotCalled = true
        displayOlderHitsViewModel = viewModel
    }

    var displaySelectedHitStoryGotCalled = false
    func displaySelectedHitStory() {
        displaySelectedHitStoryGotCalled = true
    }
}
