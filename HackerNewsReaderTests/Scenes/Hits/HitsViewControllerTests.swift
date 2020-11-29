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

        sut.preloadView()
    }

    // MARK: Tests

     func testShouldDoSomethingWhenViewIsLoaded() {
        // Given
        // When
        // Then
        XCTAssertTrue(spyInteractor.grabHitsGotCalled, "viewDidLoad() should ask the interactor to do grab the hits")
    }

    func testDisplayHits() {
        /// Given
        let viewModel = Hits.FetchHits.ViewModel(hits: Seeds.Hits.hits)
        let tableViewMock = UITableViewMock()
        /// When
        sut.tableView = tableViewMock
        sut.displayHits(viewModel: viewModel)
        /// Then
        XCTAssertFalse(sut.hits.isEmpty, "The list of hits should not be empty")
        XCTAssertTrue(tableViewMock.reloadDataGotCalled)
    }

    private func cellForRow(in tableView: UITableView, row: Int, section: Int = 0) -> UITableViewCell? {
        return tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
    }

    func testReloadDataSetCorrectlyTheCell() {
        /// Given
        sut.hits = Seeds.Hits.hits
        sut.tableView.reloadData()
        /// When
        let cell = cellForRow(in: sut.tableView, row: 0)
        /// Then
        XCTAssertEqual(cell?.textLabel?.text, "Test 1", "The datasource should set the correct title for the table")
    }

    func testReloadDataSetCorrectlyNumberOfCells() {
        /// Given
        sut.hits = Seeds.Hits.hits
        /// When
        sut.tableView.reloadData()
        /// Then
        XCTAssertEqual(sut.tableView.dataSource?.numberOfSections?(in: sut.tableView), 1, "The datasource should set only 1 section for the table")
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), 2, "The datasource should set the correct title for the table")
    }
}

class UITableViewMock: UITableView {
    var reloadDataGotCalled = false
    override func reloadData() {
        super.reloadData()

        reloadDataGotCalled = true
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
