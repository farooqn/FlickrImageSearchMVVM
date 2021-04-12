//
//  FlickrNetworkOpsTest.swift
//  FlickrImageSearchTests
//
//  Created by Farooq Nasim Ahmad on 11.04.2021.
//

import XCTest
@testable import FlickrImageSearch

class FlickrNetworkOpsTests: XCTestCase {
    var sut:FlickrNetworkOps?
    override func setUpWithError() throws {
        sut = FlickrNetworkOps()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testFetchPhotoList() throws {
        let searchTerm = "Apple"
        let expectation = self.expectation(description: "Photo list is fetched")
        sut?.fetchPhotoList(withSearchTerm: searchTerm, completion: { (photoList, error) in
            XCTAssertNotNil(photoList,"photo list is nil")
            XCTAssertTrue(photoList?.count ?? 0>0, "invalid photo list")
            expectation.fulfill()
        })
        waitForExpectations(timeout: TimeInterval(10), handler: nil)
        
    }
    
    
    func testFetchPhoto() throws {
        let expectation = self.expectation(description: "Photo is fetched")
        let url = URL(string: "http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")
        let inputIndexPath = IndexPath(row: 1, section: 0)
        sut?.fetchPhoto(photoURL: url!, indexPath: inputIndexPath, completion: { (image, indexPath, error) in
            XCTAssertNotNil(image,"image is nil")
            XCTAssertEqual(inputIndexPath, indexPath,"invalid index path")
            XCTAssertEqual(error,.none,"\(error)")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval(10), handler: nil)
    }
    
}
