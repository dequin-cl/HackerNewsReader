//
//  AppStoryboard.swift
//  login
//
//  Created by Oğulcan on 20/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import UIKit

enum AppStoryboard: String {

    case Hits
    case Story

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }

        return scene
    }
}

extension UIStoryboard {
//    @available(*, deprecated, message: "Parse your data by hand instead")
//    func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
//
//    }
}
