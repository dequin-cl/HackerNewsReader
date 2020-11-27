//
//  HackerNewsModelTests.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 27-11-20.
//

import XCTest
@testable import HackerNewsReader

class HitDTOModelTests: XCTestCase {

    func testModelFromValidNoTitleJSON_Succeed() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleNews.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        /// When
        let hitDTO = try HitDTO(data: json)
        
        /// Then
        // Story Title
        XCTAssertNotNil(hitDTO.storyTitle, "Hit needs to parse story_title")
        XCTAssertEqual(hitDTO.storyTitle, "Fucking, Austria changes name to Fugging", "Hit should have the same story_title as the sample data in SampleNews.json")
        
        // Title
        XCTAssertNil(hitDTO.title, "Hit needs to parse title, and should be nil")
        
        // Author
        XCTAssertNotNil(hitDTO.author, "Hit needs to parse author")
        XCTAssertEqual(hitDTO.author, "amiga-workbench", "Hit should have the same author as the sample data in SampleNews.json")

        // Creation
        XCTAssertNotNil(hitDTO.createdAt, "Hit needs to parse created_at")
        let dateFormatter = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
        let date = dateFormatter.date(from: "2020-11-26T23:09:43.000Z")
        XCTAssertEqual(hitDTO.createdAt, date, "Hit should parse creation date correctly")
        
    }
    
    func testModelFromValidWithTitleJSON_Succeed() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews2", withExtension: "json") else {
            XCTFail("Missing file: SampleNews2.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        /// When
        let hitDTO = try HitDTO(data: json)
        
        /// Then
        // Story Title
        XCTAssertNil(hitDTO.storyTitle, "Hit needs to parse story_title and should be nil")

        // Title
        XCTAssertNotNil(hitDTO.title, "Hit needs to parse title")
        XCTAssertEqual(hitDTO.title, "Improve your forecasting skills with each avocado you open", "Hit should have the same title as the sample data in SampleNews2.json")
        
        // Author
        XCTAssertNotNil(hitDTO.author, "Hit needs to parse author")
        XCTAssertEqual(hitDTO.author, "kadavy", "Hit should have the same author as the sample data in SampleNews2.json")

        // Creation
        XCTAssertNotNil(hitDTO.createdAt, "Hit needs to parse created_at")
        let dateFormatter = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
        let date = dateFormatter.date(from: "2020-11-26T23:08:36.000Z")
        XCTAssertEqual(hitDTO.createdAt, date, "Hit should parse creation date correctly")
        
        // Identifier
        XCTAssertEqual(hitDTO.objectID, "25224210", "Hit should parse and set Object Id")
    }
}

