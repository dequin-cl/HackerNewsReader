//
//  HitsCoreDataWorkerTest.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 28-11-20.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length

@testable import HackerNewsReader
import XCTest

class HitsCoreDataWorkerTest: XCTestCase {

    var persistanceController: PersistenceController!

    override func setUpWithError() throws {
        self.persistanceController = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        self.persistanceController.clearContainer()
        self.persistanceController = nil
    }

    // MARK: Subject under test

    var sut: HitsCoreDataWorker!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitsWorker()
    }

    override  func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitsWorker() {
        sut = HitsCoreDataWorker()
        sut.persistenceController = self.persistanceController
    }

    // MARK: Tests

    func testFetchHits() throws {

        /// Given
        let feedServiceMock = FeedServiceMock(persistenceController: self.persistanceController)

        /// When
        sut.fetchHits(feedService: feedServiceMock) { (hits, error) in

            /// Then

            XCTAssertNil(error)
            XCTAssertNotNil(hits)
            XCTAssertFalse(hits!.isEmpty)
            XCTAssertEqual(hits?.count, 2, "The number of Hits.HitPresentationModel should be 2, same as the sample data provided")
        }

    }

}

private class FeedServiceMock: FeedService {
    var feedGotCalled = false
    var persistenceControllerMocked: PersistenceController

    init(persistenceController: PersistenceController) {
        persistenceControllerMocked = persistenceController
    }

    override func feed(limit: Int = 20, offset: Int = 0, _ block: @escaping ([Hit]) -> Void) {
        feedGotCalled = true
        block(Seeds.HitSamples.hits(persistenceController: persistenceControllerMocked))
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
