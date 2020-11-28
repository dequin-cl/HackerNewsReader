//
//  HitsRoutingLogicSpy.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

@testable import HackerNewsReader
import Foundation

class HitsRoutingLogicSpy: NSObject, HitsRoutingLogic, HitsDataPassing {
    var dataStore: HitsDataStore?
}
