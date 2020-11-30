//
//  HitStoryWorkerTests.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
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

class HitStoryWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: HitStoryWorker!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupHitStoryWorker()
    }

    override  func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitStoryWorker() {
        sut = HitStoryWorker()
    }

    // MARK: Tests

//     func testFetchSomethingSuccess() {
//        // Given
//        let fakeJsonFile = "POST_Fake_Json_File.json"
//        let bundle = Utils.bundle(forClass: HitStoryViewController.classForCoder())
//
//        let url = Configuration.Api.someEndPoint
//
//        guard let urlPath = URL(string: url)?.path else { XCTFail("testFetchSomething url error"); return }
//        stub(condition: isPath(urlPath)) { _ in
//            return fixture(
//                filePath: OHPathForFileInBundle(fakeJsonFile, bundle!)!,
//                status: 200,
//                headers: ["Content-Type" as NSObject: "application/json" as AnyObject]
//            )
//        }
//
//        let expectation = self.expectation(description: "calls the callback with a resource object")
//
//        // When
//        sut.fetchSomething() { (something, _, status) in
//            // Then
//            XCTAssertEqual(status, 200, "should equal 200")
//            XCTAssertEqual(something?.someVariable, "", "someVariable should match json")
//            XCTAssertEqual(something?.someOtherVariable, "", "someOtherVariable should match json")
//            expectation.fulfill()
//        }
//
//        self.waitForExpectations(timeout: 0.3, handler: nil)
//        OHHTTPStubs.removeAllStubs()
//    }

//     func testFetchSomethingFail() {
//        // Given
//        let url = Configuration.Api.someEndPoint
//
//        guard let urlPath = URL(string: url)?.path else { XCTFail("testFetchSomething url error"); return }
//
//        stub(condition: isPath(urlPath)) { _ in
//            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
//            return OHHTTPStubsResponse(error: notConnectedError)
//        }
//        let expectation = self.expectation(description: "down network")
//
//        // When
//        sut.fetchSomething() { (_, error, _) in
//            // Then
//            XCTAssertNotNil(error)
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 0.3, handler: nil)
//        OHHTTPStubs.removeAllStubs()
//    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
