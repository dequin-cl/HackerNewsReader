//
//  HitStoryDisplayLogicSpy.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader

class HitStoryDisplayLogicSpy: HitStoryDisplayLogic {
    var loadURLGotCalled = false
    var loadURLViewModel: HitStory.ShowStory.ViewModel?
    func loadURL(viewModel: HitStory.ShowStory.ViewModel) {
        loadURLGotCalled = true
        loadURLViewModel = viewModel
    }
}
