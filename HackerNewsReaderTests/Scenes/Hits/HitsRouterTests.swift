//
//  HitsRouterTests.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length

@testable import HackerNewsReader
import XCTest
import SafariServices

class HitsRouterTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitsRouter!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitsRouter()
    }

    override  func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitsRouter() {
        sut = HitsRouter()
    }

    // MARK: Tests
    func testRouteToStoryCallsNavigationAnsPassingData() {
        /// Given
        let sut = HitsRouterMock()
        sut.dataStore = HitsInteractor()
        sut.viewController = HitsViewController.instantiate(from: .Hits)
        /// When
        sut.routeToStoryDetail(segue: nil)
        /// Then
        XCTAssertTrue(sut.navigateToStoryDetailGotCalled, "Router should call to navigation")
        XCTAssertNotNil(sut.navigateToStoryDetailDestination)
    }

    func testNavigateToStoryDetails() {
        /// Given
        let mockVC = ViewControllerMock()
        /// When
        sut.navigateToStoryDetail(source: mockVC, destination: SFSafariViewController(url: URL(string: "https://local")!))
        /// Then
        XCTAssertTrue(mockVC.presentGotCalled, "The navigation should use present")
        XCTAssertTrue(mockVC.presentViewControllerToPresent is SFSafariViewController, "The navigation should be to a SFSafariViewController")

    }
}

class ViewControllerMock: UIViewController {

    var presentGotCalled = false
    var presentViewControllerToPresent: UIViewController?
    var presentAnimatedFlag: Bool = false
    var presentCompletion: (() -> Void)?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentGotCalled = true
        presentViewControllerToPresent = viewControllerToPresent
        presentAnimatedFlag = flag
        presentCompletion = completion
    }
}

class HitsRouterMock: HitsRouter {
    var navigateToStoryDetailGotCalled = false
    var navigateToStoryDetailDestination: SFSafariViewController?
    override func navigateToStoryDetail(source: UIViewController, destination: SFSafariViewController) {
        navigateToStoryDetailGotCalled = true
        navigateToStoryDetailDestination = destination
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
