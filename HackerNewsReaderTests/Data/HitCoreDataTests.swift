//
//  HitCoreDataTests.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 27-11-20.
//

import XCTest

@testable import HackerNewsReader

class HitCoreDataTests: XCTestCase {

    var persistanceController: PersistenceController!

    override func setUpWithError() throws {
        self.persistanceController = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        self.persistanceController = nil
    }

    func testInitializeFromDTO() throws {
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleNews", withExtension: "json") else {
            XCTFail("Missing file: SampleNews.json")
            return
        }

        let json = try Data(contentsOf: url)
        let hitDTO = try HitDTO(data: json)

        /// When
        let hitCD = Hit.from(hitDTO, in: persistanceController.container.viewContext)

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
}
