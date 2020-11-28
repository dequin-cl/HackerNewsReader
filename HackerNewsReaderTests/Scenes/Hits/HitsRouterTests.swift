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

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
