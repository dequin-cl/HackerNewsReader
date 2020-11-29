//
//  FeedServiceTest.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 27-11-20.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length

import XCTest
import CoreData
@testable import HackerNewsReader

class FeedServiceTest: XCTestCase {

    var persistanceController: PersistenceController!

    override func setUpWithError() throws {
        self.persistanceController = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        self.persistanceController = nil
    }

    func testAddHit() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleNews.json")
            return
        }

        let json = try Data(contentsOf: url)
        let hitDTO = try HitDTO(data: json)
        let feedService = FeedService(persistenceController: persistanceController)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }

        /// When
        feedService.add(hitDTO) { (hitCD) in

            /// Then
            XCTAssertNotNil(hitCD, "The Hit should be created on Core Data")
            XCTAssertEqual(hitCD.author, hitDTO.author)
            XCTAssertEqual(hitCD.createdAt, hitDTO.createdAt)
            XCTAssertEqual(hitCD.id, hitDTO.objectID)
            XCTAssertEqual(hitCD.storyTitle, hitDTO.storyTitle)
            XCTAssertEqual(hitCD.storyURL, hitDTO.storyURL)
            XCTAssertNil(hitCD.title)
            XCTAssertNil(hitCD.url)

            XCTAssertFalse(hitCD.isUserDeleted)
        }

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

    }

    func testGetFeed() throws {
        /// Given
        let feedService = FeedService(persistenceController: persistanceController)

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, 0)
        }

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleNews.json")
            return
        }

        let json = try Data(contentsOf: url)
        let hitDTO = try HitDTO(data: json)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }

        feedService.add(hitDTO) {_ in }

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, 1)

            if let hit = hits.first {
                print(hit)

                if let identifier = hit.id {
                    XCTAssertEqual(identifier, hitDTO.objectID)
                }
            }
        }
    }

    func testParseFeedDTO() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleJSON", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }

        let json = try Data(contentsOf: url)
        let feedDTO = try FeedDTO(data: json)
        let feedService = FeedService(persistenceController: persistanceController)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }

        /// When
        feedService.process(feedDTO.hits)
        /// Then

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, feedDTO.hits.count)
        }
    }

    func testParseFeedLimitResponseDTO() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleJSON", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }

        let json = try Data(contentsOf: url)
        let feedDTO = try FeedDTO(data: json)
        let feedService = FeedService(persistenceController: persistanceController)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }

        /// When
        feedService.process(feedDTO.hits)
        /// Then

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        feedService.feed(limit: 2) { (hits) in
            XCTAssertEqual(hits.count, 2)
        }
    }

    func testParseTwiceFeedDTO() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleJSON", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }

        let json = try Data(contentsOf: url)
        let feedDTO = try FeedDTO(data: json)
        let feedService = FeedService(persistenceController: persistanceController)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }

        /// When
        feedService.process(feedDTO.hits)
        /// Then

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        expectation(forNotification: .NSManagedObjectContextWillSave, object: nil) { _ in
            return true
        }

        /// When
        feedService.process(feedDTO.hits)
        /// Then

        waitForExpectations(timeout: 2.0) { _ in }

        let expectation = XCTestExpectation(description: "Fetching hits")

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, feedDTO.hits.count)

            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)

    }

    func testFeedShowsSortedByDateDecreasing() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let first = bundle.url(forResource: "first", withExtension: "json") else {
            XCTFail("Missing file: first.json")
            return
        }

        guard let second = bundle.url(forResource: "second", withExtension: "json") else {
            XCTFail("Missing file: second.json")
            return
        }

        let json = try Data(contentsOf: first)
        let feedDTO = try FeedDTO(data: json)

        let jsonSecond = try Data(contentsOf: second)
        let feedDTOSecond = try FeedDTO(data: jsonSecond)

        let feedService = FeedService(persistenceController: persistanceController)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }

        let expectedOrder = ["2020-11-27T23:09:43.000Z",
                             "2020-11-26T23:00:24.000Z",
                             "2020-11-26T23:00:16.000Z",
                             "2020-11-21T23:09:28.000Z"]
        /// When
        feedService.process(feedDTO.hits)
        feedService.process(feedDTOSecond.hits)
        /// Then

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        let expectation = XCTestExpectation(description: "Fetching hits")

        feedService.feed { (hits) in

            for index in 0..<hits.count {

                let receivedDateTimeInterval = hits[index].createdAt!.timeIntervalSinceReferenceDate
                let expectedDateTimeInterval = DateFormatter.iso8601withFractionalSeconds.date(from: expectedOrder[index])!.timeIntervalSinceReferenceDate
                XCTAssertEqual(receivedDateTimeInterval, expectedDateTimeInterval, accuracy: 0.001)
            }

            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)

    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
