//
//  HitsCoreDataWorkerTest.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 28-11-20.
//

@testable import HackerNewsReader
import XCTest

class HitsCoreDataWorkerTest: XCTestCase {
    
    var persistanceController: PersistenceController!
    
    override func setUpWithError() throws {
        self.persistanceController = PersistenceController(inMemory: true)
    }
    
    override func tearDownWithError() throws {
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
    }

    // MARK: Tests
    
    func testFetchHits() throws {
        
        /// Given
        let bundle = Bundle(for: type(of: self))
        guard let sample = bundle.url(forResource: "SampleJSON", withExtension: "json") else {
            XCTFail("Missing file: SampleJSON.json")
            return
        }
        
        let data = try Data(contentsOf: sample)
        let feedDTO = try FeedDTO(data: data)
        let feedService = FeedService(persistenceController: persistanceController)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil) { _ in
            return true
        }
        
        feedService.process(feedDTO.hits)
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        /// When
        
        let expectation = XCTestExpectation(description: "Fetching hits")

        /// When
        sut.fetchHits(persistenceController: persistanceController) { (hits, error) in
            
            /// Then
            
            XCTAssertNil(error)
            XCTAssertNotNil(hits)
            XCTAssertFalse(hits!.isEmpty)
            XCTAssertEqual(hits?.count, feedDTO.hits.count, "The number of hits on the ddbb should be the same as the number of hits processed from the json")

            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 1.0)
        
    }

}
