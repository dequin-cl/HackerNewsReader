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
        XCTAssertTrue(sut.passDataToStoryDetailGotCalled, "Router should call to pass data")
        XCTAssertTrue(sut.navigateToStoryDetailGotCalled, "Router should call to navigation")
    }

    func testNavigateToStoryDetails() {
        /// Given
        let mockVC = ViewControllerMock()
        /// When
        sut.navigateToStoryDetail(source: mockVC, destination: HitStoryViewController())
        /// Then
        XCTAssertTrue(mockVC.showGotCalled, "The navigation should use Show")
        XCTAssertTrue(mockVC.vcUIViewController is HitStoryViewController, "The navigation should be to a HitStoryViewController")

    }

    func testPassDataToStoryDetails() {
        /// Given
        let destinationVC = HitStoryViewController()
        var destinationDS = destinationVC.router!.dataStore!
        let hitsInteractor = HitsInteractor()
        hitsInteractor.selectedHitURL = "TEST"
        /// When
        sut.passDataToStoryDetail(source: hitsInteractor, destination: &destinationDS)
        /// Then
        XCTAssertNotNil(destinationDS.hitURL, "Should pass the value of the selected hit URL")
        XCTAssertEqual(destinationDS.hitURL, "TEST", "Should pass the correct value")
    }
}

class ViewControllerMock: UIViewController {

    var showGotCalled = false
    var vcUIViewController: UIViewController?
    override func show(_ vc: UIViewController, sender: Any?) {
        showGotCalled = true
        vcUIViewController = vc
    }
}

class HitsRouterMock: HitsRouter {
    var passDataToStoryDetailGotCalled = false
    override func passDataToStoryDetail(source: HitsDataStore, destination: inout HitStoryDataStore) {
        passDataToStoryDetailGotCalled = true
    }

    var navigateToStoryDetailGotCalled = false
    override func navigateToStoryDetail(source: UIViewController, destination: HitStoryViewController) {
        navigateToStoryDetailGotCalled = true
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
