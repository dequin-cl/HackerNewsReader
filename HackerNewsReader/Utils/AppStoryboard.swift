//
//  AppStoryboard.swift
//  login
//
//  Created by Oğulcan on 20/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import UIKit

//swiftlint:disable identifier_name
enum AppStoryboard: String {

    case Hits
    case HitStory

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type,
                                             function: String = #function,
                                             line: Int = #line,
                                             file: String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("""
            ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.
            File : \(file)
            Line Number : \(line)
            Function : \(function)
            """)
        }

        return scene
    }
}
//swiftlint:enable identifier_name
