//
//  HitsPresenterTests.swift
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

class HitsPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitsPresenter!
    var spyViewController: HitsDisplayLogicSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitsPresenter()
    }

    override  func tearDown() {
        spyViewController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitsPresenter() {
        sut = HitsPresenter()

        spyViewController = HitsDisplayLogicSpy()
        sut.viewController = spyViewController
    }

    // MARK: Tests

    func testPresent() {
        /// Given
        let response = Hits.FetchHits.Response(hits: Seeds.HitSamples.hitsPresentation)
        /// When
        sut.presentHits(response: response)
        /// Then
        XCTAssertTrue(spyViewController.displayHitsGotCalled, "Presenter should call the View Controller")
    }

    func testPresentOlder() {
        /// Given
        let response = Hits.FetchHits.Response(hits: Seeds.HitSamples.hitsPresentation)
        /// When
        sut.presentOlderHits(response: response)
        /// Then
        XCTAssertTrue(spyViewController.displayOlderHitsGotCalled, "Presenter should call the View Controller")
    }

    func testPresentHitShouldCallVC() {
        /// Given

        /// When
        sut.presentHit()
        /// Then
        XCTAssertTrue(spyViewController.displaySelectedHitStoryGotCalled, "Presenter should call the VC to display the Story")
    }

    func testDeleteCallsVC() {
        /// Given
        let response = Hits.Delete.Response(row: 0)
        /// When
        sut.deleteHit(response: response)
        /// Then
        XCTAssertTrue(spyViewController.updateHitsWithDeletionGotCalled, "Presenter should call the vc")
        XCTAssertEqual(spyViewController.updateHitsWithDeletionViewModel?.row, 0)
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
