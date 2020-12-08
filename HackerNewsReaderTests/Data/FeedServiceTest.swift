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
        self.persistanceController.clearContainer()
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
        let feedService = FeedService()
        feedService.persistenceController = persistanceController

        let expectationSaved = expectation(description: "Saving Hit")
        /// When
        feedService.add(hitDTO) { (hitCD) in
            expectationSaved.fulfill()
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

        wait(for: [expectationSaved], timeout: 20.0)

    }

    func testGetFeed() throws {
        /// Given
        let feedService = FeedService()
        feedService.persistenceController = persistanceController
        /// I want to be sure that the feed is empty
        let expectationFetchEmpty = XCTestExpectation(description: "Fetching should be empty")

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, 0)

            expectationFetchEmpty.fulfill()

        }

        wait(for: [expectationFetchEmpty], timeout: 10.0)

        /// Load the sample data
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleNews.json")
            return
        }

        let json = try Data(contentsOf: url)
        let hitDTO = try HitDTO(data: json)

        let expectationSaved = expectation(description: "Saving Hit")

        feedService.add(hitDTO) {_ in
            expectationSaved.fulfill()

        }

        wait(for: [expectationSaved], timeout: 2.0)

        let expectationFetchNotEmpty = XCTestExpectation(description: "Fetching should not be empty")

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, 1)

            if let hit = hits.first {

                if let identifier = hit.id {
                    XCTAssertEqual(identifier, hitDTO.objectID)
                }
            }
            expectationFetchNotEmpty.fulfill()
        }

        wait(for: [expectationFetchNotEmpty], timeout: 10.0)

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
        let feedService = FeedService()
        feedService.persistenceController = persistanceController

        let expectationProcessFinished = XCTestExpectation(description: "Processing Feed DTO")

        /// When
        feedService.process(feedDTO.hits) {
            expectationProcessFinished.fulfill()
        }
        /// Then

        wait(for: [expectationProcessFinished], timeout: 2.0)

        let expectationFetching = XCTestExpectation(description: "Fetching hits")

        feedService.feed { (hits) in
            XCTAssertEqual(hits.count, feedDTO.hits.count)
            expectationFetching.fulfill()
        }

        wait(for: [expectationFetching], timeout: 2.0)

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
        let feedService = FeedService()
        feedService.persistenceController = persistanceController

        let expectationProcessFinished = XCTestExpectation(description: "Processing Feed DTO")

        /// When
        feedService.process(feedDTO.hits) {
            expectationProcessFinished.fulfill()
        }
        /// Then

        wait(for: [expectationProcessFinished], timeout: 2.0)

        let expectationFetchNotEmpty = XCTestExpectation(description: "Fetching should not be empty")

        feedService.feed(limit: 2) { (hits) in
            XCTAssertEqual(hits.count, 2)
            expectationFetchNotEmpty.fulfill()

        }

        wait(for: [expectationFetchNotEmpty], timeout: 10.0)

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
        let feedService = FeedService()
        feedService.persistenceController = persistanceController

        let expectationFirstProcess = expectation(description: "First process")

        /// When
        feedService.process(feedDTO.hits) {
            expectationFirstProcess.fulfill()
        }
        /// Then

        wait(for: [expectationFirstProcess], timeout: 2.0)

        let expectationSecondProcess = expectation(description: "Second process")
        /// When
        feedService.process(feedDTO.hits) {
            expectationSecondProcess.fulfill()
        }
        wait(for: [expectationSecondProcess], timeout: 2.0)

        /// Then
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

        let feedService = FeedService()
        feedService.persistenceController = persistanceController

        let expectedOrder = ["2020-11-27T23:09:43.000Z",
                             "2020-11-26T23:00:24.000Z",
                             "2020-11-26T23:00:16.000Z",
                             "2020-11-21T23:09:28.000Z"]

        /// When
        let expectationFirstProcess = expectation(description: "First process")
        let expectationSecondProcess = expectation(description: "Second process")

        feedService.process(feedDTO.hits) {
            expectationFirstProcess.fulfill()

            feedService.process(feedDTOSecond.hits) {
                expectationSecondProcess.fulfill()
            }
        }

        wait(for: [expectationFirstProcess, expectationSecondProcess], timeout: 10.0)

        /// Then

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
