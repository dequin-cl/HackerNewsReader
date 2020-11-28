//
//  HitsRouter.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

@objc protocol HitsRoutingLogic {
}

protocol HitsDataPassing {
    var dataStore: HitsDataStore? { get }
}

class HitsRouter: NSObject, HitsRoutingLogic, HitsDataPassing {
    weak var viewController: HitsViewController?
    var dataStore: HitsDataStore?
}
