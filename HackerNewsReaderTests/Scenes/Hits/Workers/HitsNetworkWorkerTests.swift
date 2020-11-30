//
//  HitsNetworkWorkerTests.swift
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

//import OHHTTPStubs
@testable import HackerNewsReader
import XCTest

class HitsNetworkWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitsNetworkWorker!

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
        sut = HitsNetworkWorker()
    }

    // MARK: Tests

    func testFetchHits() throws {
        /// Given

        let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?query=ios&tags=story")!

        let bundle = Bundle(for: type(of: self))
        guard let jsonURL = bundle.url(forResource: "first", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }

        let data = try Data(contentsOf: jsonURL)

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let expectation = XCTestExpectation(description: "Fetching hits")

        /// When
        sut.fetchHits(session: mockSession) { (hitsDTO, error) in

            /// Then

            XCTAssertNil(error)
            XCTAssertNotNil(hitsDTO)
            XCTAssertEqual(hitsDTO?.count, 2)
            XCTAssertEqual(hitsDTO?.first?.storyTitle, "Fucking, Austria changes name to Fugging")

            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 1.0)

    }

    func testFetchHitsBadJSON() throws {
        /// Given

        let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?query=ios&tags=story")!

        let bundle = Bundle(for: type(of: self))
        guard let jsonURL = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }

        let data = try Data(contentsOf: jsonURL)

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let expectation = XCTestExpectation(description: "Fetching hits")

        /// When
        sut.fetchHits(session: mockSession) { (hitsDTO, error) in

            /// Then

            XCTAssertNotNil(error)
            XCTAssertNil(hitsDTO)

            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 1.0)

    }

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
