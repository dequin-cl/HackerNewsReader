//
//  HitsInteractorTests.swift
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

class HitsInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitsInteractor!
    var spyPresenter: HitsPresentationLogicSpy!
    var spyWorker: HitsWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitsInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitsInteractor() {
        sut = HitsInteractor()

        spyPresenter = HitsPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = HitsWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    class HitsWorkerSpy: HitsWorker {
//         var fetchSomethingCalled = false
//        override  func fetchSomething(completionHandler: @escaping ([SomethingDecodable]?, Error?) -> Void) {
//            fetchSomethingCalled = true
//        }
    }

    // MARK: Tests

//     func testDoSomething() {
//        // Given
//        let request = Hits.Something.Request()
//        // When
//        sut.doSomething(request: request)
//        // Then
//        XCTAssertTrue(spyWorker.fetchSomethingCalled, "doSomething(request:) should ask the worker to fetch something")
//        XCTAssertTrue(spyPresenter.presentSomethingCalled, "doSomething(request:) should ask the presenter to format the result")
//    }

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
