//
//  HitStoryPresenterTests.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
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

class HitStoryPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitStoryPresenter!
    var spyViewController: HitStoryDisplayLogicSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitStoryPresenter()
    }

    override  func tearDown() {
        spyViewController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitStoryPresenter() {
        sut = HitStoryPresenter()

        spyViewController = HitStoryDisplayLogicSpy()
        sut.viewController = spyViewController
    }

    // MARK: Tests

    func testPresentURL() {
        /// Given

        /// When
        sut.presentURL(response: HitStory.ShowStory.Response(url: "TEST"))
        /// Then
        XCTAssertTrue(spyViewController.loadURLGotCalled, "Presenter should call the VC to load the URL")
        XCTAssertEqual(spyViewController.loadURLViewModel?.url, "TEST", "Presenter should call the VC with the correct URL")
    }

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
