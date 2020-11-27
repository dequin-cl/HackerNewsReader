//
//  HitCoreDataTests.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 27-11-20.
//

import XCTest
@testable import HackerNewsReader

class HitCoreDataTests: XCTestCase {
    
    func testInitializeFromDTO() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleNews.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        let hitDTO = try HitDTO(data: json)
        let viewContext = PersistenceController.emptyPreview.container.viewContext
        
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: viewContext) { _ in
            return true
        }
        
        /// When
        viewContext.perform {
            let hitCD = Hit.from(dto: hitDTO, in: viewContext)
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
    
    func testInitializeFromDTO2() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews2", withExtension: "json") else {
            XCTFail("Missing file: SampleNews2.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        let hitDTO = try HitDTO(data: json)
        let viewContext = PersistenceController.emptyPreview.container.viewContext
        
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: viewContext) { _ in
            return true
        }
        
        /// When
        viewContext.perform {
            let hitCD = Hit.from(dto: hitDTO, in: viewContext)
            /// Then
            XCTAssertNotNil(hitCD, "The Hit should be created on Core Data")
            XCTAssertEqual(hitCD.author, hitDTO.author)
            XCTAssertEqual(hitCD.createdAt, hitDTO.createdAt)
            XCTAssertEqual(hitCD.id, hitDTO.objectID)
            XCTAssertNil(hitCD.storyTitle)
            XCTAssertNil(hitCD.storyURL)
            XCTAssertEqual(hitCD.title, hitDTO.title)
            XCTAssertEqual(hitCD.url, hitDTO.url)
            XCTAssertFalse(hitCD.isUserDeleted)
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
}
