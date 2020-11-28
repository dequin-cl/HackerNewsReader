//
//  HitsViewControllerTests.swift
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

class HitsViewControllerTests: XCTestCase {
    // MARK: Subject under test
    var sut: HitsViewController!
    var spyInteractor: HitsBusinessLogicSpy!
    var spyRouter: HitsRoutingLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        window = UIWindow()
        setupHitsViewController()
    }

    override  func tearDown() {
        spyInteractor = nil
        spyRouter = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitsViewController() {
        sut = HitsViewController.instantiate(from: .Hits)

        
        spyInteractor = HitsBusinessLogicSpy()
        sut.interactor = spyInteractor

        spyRouter = HitsRoutingLogicSpy()
        sut.router = spyRouter

        loadView()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Tests

//     func testShouldDoSomethingWhenViewIsLoaded() {
//        // Given
//        // When
//        // Then
//        XCTAssertTrue(spyInteractor.doSomethingCalled, "viewDidLoad() should ask the interactor to do something")
//        XCTAssertEqual(spyInteractor.doSomethingRequest?.someVariable, "some value", "doSomething(request:) have the proper information")
//    }

//     func testDisplaySomething() {
//        // Given
//        let viewModel = Hits.Something.ViewModel()
//        // When
//        sut.displaySomething(viewModel: viewModel)
//        // Then
//        XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
//    }

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
