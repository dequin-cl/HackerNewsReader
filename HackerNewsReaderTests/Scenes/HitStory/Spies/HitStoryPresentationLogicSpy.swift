//
//  HitStoryPresentationLogicSpy.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader

class HitStoryPresentationLogicSpy: HitStoryPresentationLogic {

    var presentURLGotCalled = false
    var presentURLResponse: HitStory.ShowStory.Response?
    func presentURL(response: HitStory.ShowStory.Response) {
        presentURLGotCalled = true
        presentURLResponse = response
    }
}
