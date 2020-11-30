//
//  HitStoryRoutingLogicSpy.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader
import Foundation

class HitStoryRoutingLogicSpy: NSObject, HitStoryRoutingLogic, HitStoryDataPassing {
    var dataStore: HitStoryDataStore?
}
