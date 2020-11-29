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
}
