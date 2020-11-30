//
//  HitStoryRouter.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

@objc
protocol HitStoryRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol HitStoryDataPassing {
    var dataStore: HitStoryDataStore? { get }
}

class HitStoryRouter: NSObject, HitStoryRoutingLogic, HitStoryDataPassing {
    weak var viewController: HitStoryViewController?
    var dataStore: HitStoryDataStore?

    // MARK: Routing

    // func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}

    // MARK: Navigation

    // func navigateToSomewhere(source: HitStoryViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    // func passDataToSomewhere(source: HitStoryDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
