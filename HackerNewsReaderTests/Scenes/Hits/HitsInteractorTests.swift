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
    var spyNetworkWorker: HitsNetworkWorkerSpy!
    var spyCoreDataWorker: HitsCoreDataWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitsInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyNetworkWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitsInteractor() {
        sut = HitsInteractor()

        spyPresenter = HitsPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyNetworkWorker = HitsNetworkWorkerSpy()
        sut.workerNetwork = spyNetworkWorker

        spyCoreDataWorker = HitsCoreDataWorkerSpy()
        sut.workerCoreData = spyCoreDataWorker
    }

    // MARK: Test doubles

    class HitsNetworkWorkerSpy: HitsNetworkWorker {
        var fetchHitsGotCalled = false
        override func fetchHits(session: URLSession = URLSession(configuration: .default), block: @escaping ([HitDTO]?, Error?) -> Void) {
            fetchHitsGotCalled = true

            block(Seeds.HitSamples.hitsDTO, nil)
        }
    }

    class HitsCoreDataWorkerSpy: HitsCoreDataWorker {
        var fetchHitsGotCalled = false
        override func fetchHits(offset: Int = 0, persistenceController: PersistenceController = PersistenceController.shared, block: @escaping ([Hits.HitPresentationModel]?, Error?) -> Void) {
            fetchHitsGotCalled = true

            block(Seeds.HitSamples.hitsPresentation, nil)
        }
    }

    // MARK: Tests
    func testGrabHitsCallsNetworkWorker() {
        /// Given

        /// When
        sut.grabHits()
        /// Then

        XCTAssertTrue(spyCoreDataWorker.fetchHitsGotCalled, "Hits Interactor should call the core data worker")
        XCTAssertTrue(spyNetworkWorker.fetchHitsGotCalled, "Hits Interactor should call the network worker")

        XCTAssertTrue(spyPresenter.presentHitsGotCalled, "Hits Interactor should call the presenter with the full list of fetched hits")
        XCTAssertEqual(spyPresenter.presentHitsResponse?.hits.count, 2, "Hits Interactor should call the presenter with the result from the Core data")

    }

    func testGrabHitsSetDatasourceHits() {
        /// Given
        /// When
        sut.grabHits()
        /// Then
        XCTAssertEqual(sut.hits.count, 2, "Hits Interactor should set the hits in the datasource with the result from the Core data")
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
