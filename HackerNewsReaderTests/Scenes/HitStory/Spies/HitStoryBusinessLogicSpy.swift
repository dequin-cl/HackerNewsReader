//
//  HitStoryBusinessLogicSpy.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader

class HitStoryBusinessLogicSpy: HitStoryBusinessLogic {
    var processHitGotCalled = false
    func processHit() {
        processHitGotCalled = true
    }
}
