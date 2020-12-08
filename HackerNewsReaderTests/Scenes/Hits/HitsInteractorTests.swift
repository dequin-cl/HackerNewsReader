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
        override func fetchHits(offset: Int = 0, feedService: FeedService = FeedService(), block: @escaping ([Hits.HitPresentationModel]?, Error?) -> Void) {
            fetchHitsGotCalled = true

            block(Seeds.HitSamples.hitsPresentation, nil)
        }

        var deleteHitGotCalled = false
        var deleteHitURL: String?
        var deleteBlock:(() -> Void)?
        override func deleteHit(url: String, block: @escaping () -> Void) {
            deleteHitGotCalled = true
            deleteHitURL = url
            deleteBlock = block

            block()
        }
    }

    // MARK: Tests
    func testGrabHitsCallsNetworkWorker() {
        /// Given
        let sut = HitsInteractorMockGrabHitTest()
        /// When
        sut.grabHits()
        /// Then

        XCTAssertTrue(sut.grabFromCoreDataGotCalled, "Hits Interactor should call the grab from core data method")
        XCTAssertTrue(sut.grabFromNetworkGotCalled, "Hits Interactor should call the grab from Network method")

    }

    func testGrabFromCoreDataShouldCallPresenterOlderHitsWhenIsFetchingOlderHits() {
        /// Given
        sut.isFetchingOlderHits = true
        /// When
        sut.grabFromCoreData()
        /// Then
        XCTAssertTrue(spyPresenter.presentOlderHitsGotCalled, "Hits Interactor should call the presenter with the full list of fetched hits")
        XCTAssertEqual(spyPresenter.presentOlderHitsResponse?.hits.count, 2, "Hits Interactor should call the presenter with the result from the Core data")
    }

    func testGrabFromCoreDataShouldCallPresenterHitsWhenCallingNormalHits() {
        /// Given

        /// When
        sut.grabFromCoreData()
        /// Then
        XCTAssertTrue(spyPresenter.presentHitsGotCalled, "Hits Interactor should call the presenter with the full list of fetched hits")
        XCTAssertEqual(spyPresenter.presentHitsResponse?.hits.count, 2, "Hits Interactor should call the presenter with the result from the Core data")
    }

    func testGrabNetworkShouldCallFeedServiceProcessWhenThereIsNoError() {
        /// Given
        let feedServiceMock = FeedServiceMock()
        sut.feedService = feedServiceMock
        /// When
        sut.grabFromNetwork(block: {})
        /// Then
        XCTAssertTrue(spyNetworkWorker.fetchHitsGotCalled, "The grab network process should call the network worker")
        XCTAssertTrue(feedServiceMock.processGotCalled, "The grab network process should call the feedservice to process")
    }

    func testGrabFromCoreDataShouldSetDatasourceHits() {
        /// Given
        /// When
        sut.grabFromCoreData()
        /// Then

        XCTAssertEqual(sut.hits.count, 2, "Hits Interactor should set the hits in the datasource with the result from the Core data")
    }

    func testGrabOldHitsCallsNetworkWorker() {
        /// Given

        /// When
        sut.grabOlderHits(request: Hits.FetchHits.Request(offset: 0))
        /// Then

        XCTAssertTrue(spyCoreDataWorker.fetchHitsGotCalled, "Hits Interactor should call the core data worker")

        XCTAssertTrue(spyPresenter.presentOlderHitsGotCalled, "Hits Interactor should call the presenter with the full list of fetched hits")
        XCTAssertEqual(spyPresenter.presentOlderHitsResponse?.hits.count, 2, "Hits Interactor should call the presenter with the result from the Core data")

    }

    func testSelectHitShouldSetDataStore() {
        /// Given
        let request = Hits.Show.Request(hit: Seeds.HitSamples.hitVMOne)
        /// When
        sut.selectHit(request: request)
        /// Then
        XCTAssertNotNil(sut.selectedHitURL)
        XCTAssertEqual(sut.selectedHitURL.absoluteString, Seeds.HitSamples.hitVMOne.url, "Should set the URL")
        XCTAssertTrue(spyPresenter.presentHitGotCalled, "Interactor should call the presenter")
    }

    func testDeleteHit() {
        let sut = HitsInteractorMock()
        sut.workerCoreData = spyCoreDataWorker
        sut.presenter = spyPresenter
        sut.hits = Seeds.HitSamples.hitsPresentation
        /// Given
        let request = Hits.Delete.Request(hit: Seeds.HitSamples.hitVMTwo, row: 1)
        /// When
        sut.deleteHit(request: request)
        /// Then
        XCTAssertEqual(sut.hits.count, 1)
        let exists = sut.hits.contains { (hit) -> Bool in
            hit.url == Seeds.HitSamples.hitVMTwo.url
        }

        XCTAssertFalse(exists)
        XCTAssertTrue(spyCoreDataWorker.deleteHitGotCalled, "Should call the worker to delete")

        XCTAssertTrue(spyPresenter.deleteHitGotCalled, "Should call the presenter")
    }
}

private class HitsInteractorMockGrabHitTest: HitsInteractor {

    var grabFromCoreDataGotCalled = false
    override func grabFromCoreData(offset: Int = 0, block: @escaping () -> Void = {}) {
        grabFromCoreDataGotCalled = true
        block()
    }

    var grabFromNetworkGotCalled = false
    override func grabFromNetwork(block: @escaping () -> Void) {
        grabFromNetworkGotCalled = true
        block()
    }
}

private class HitsInteractorMock: HitsInteractor {

    var grabHitsGotCalled = false
    override func grabHits() {
        grabHitsGotCalled = true
    }
}

private class FeedServiceMock: FeedService {
    var processGotCalled = false
    override func process(_ hitsDTO: [HitDTO], block: @escaping () -> Void = {}) {
        processGotCalled = true
        block()
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
