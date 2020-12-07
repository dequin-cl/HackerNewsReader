//
//  HitsRouter.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit
import SafariServices

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

        let vc = SFSafariViewController(url: dataStore!.selectedHitURL)
        navigateToStoryDetail(source: viewController!, destination: vc)
    }

    func navigateToStoryDetail(source: UIViewController, destination: SFSafariViewController) {
        source.present(destination, animated: true)
    }

}
