//
//  HitStoryInteractorTests.swift
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

class HitStoryInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitStoryInteractor!
    var spyPresenter: HitStoryPresentationLogicSpy!
    var spyWorker: HitStoryWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitStoryInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitStoryInteractor() {
        sut = HitStoryInteractor()

        spyPresenter = HitStoryPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = HitStoryWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    class HitStoryWorkerSpy: HitStoryWorker {
    }

    // MARK: Tests

    func testProcessHit() {
        /// Given
        sut.hitURL = "TEST"
        /// When
        sut.processHit()
        /// Then
        XCTAssertTrue(spyPresenter.presentURLGotCalled, "Interactor should call the presenter")
        XCTAssertEqual(spyPresenter.presentURLResponse?.url, "TEST", "Interactor should call the presenter with the URL grabbed from the hitURL")
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
