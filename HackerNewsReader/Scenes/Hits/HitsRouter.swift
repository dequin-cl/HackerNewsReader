//
//  HitsRouter.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

@objc protocol HitsRoutingLogic {
    func routeToStoryDetail(segue: UIStoryboardSegue?)
}

protocol HitsDataPassing {
    var dataStore: HitsDataStore? { get }
}

class HitsRouter: NSObject, HitsRoutingLogic, HitsDataPassing {
    weak var viewController: HitsViewController?
    var dataStore: HitsDataStore?

    func routeToStoryDetail(segue: UIStoryboardSegue?) {
        let destinationVC = HitStoryViewController.instantiate(from: .HitStory)
        var destinationDS = destinationVC.router!.dataStore!
        passDataToStoryDetail(source: dataStore!, destination: &destinationDS)
        navigateToStoryDetail(source: viewController!, destination: destinationVC)
    }

    func passDataToStoryDetail(source: HitsDataStore, destination: inout HitStoryDataStore) {
        destination.hitURL = source.selectedHitURL
    }

    func navigateToStoryDetail(source: UIViewController, destination: HitStoryViewController) {
        source.show(destination, sender: nil)
    }

}
