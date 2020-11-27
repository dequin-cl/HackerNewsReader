//
//  HitsModelTests.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 27-11-20.
//

import XCTest
@testable import HackerNewsReader

class FeedModelTests: XCTestCase {

    func testModelFromValidNoTitleJSON_Succeed() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleJSON", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        /// When
        let feed = try Feed(data: json)
        /// Then
        
        // Hits per Page
        XCTAssertEqual(feed.hitsPerPage, 20, "Should parse hitsPerPage and assign 20 as value")
        
//        // Hits are in an array of correct length
        XCTAssertNotNil(feed.hits, "Should parse hits from sample file")
//        XCTAssertEqual(feed.hits.count, feed.hitsPerPage, "The number of hits should be equal to the hits per page")
    }

}
