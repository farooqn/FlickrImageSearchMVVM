//
//  FlickrImageSearchUITests.swift
//  FlickrImageSearchUITests
//
//  Created by Farooq Nasim Ahmad on 10.04.2021.
//

import XCTest

class FlickrImageSearchUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    ///Test case: when user taps in search bar the collection view hides and table view with search history is displayed
    func testCollectionViewTableViewToggle() throws {
        XCUIDevice.shared.orientation = .portrait
        
        let flickrSearchBarElement = app.otherElements["flickr-searchbar"]
        let flickrImageCollectionViewElement =
            app.collectionViews.matching(identifier: "flickr-imagecollectionview").element
        let searchHistoryTableViewElement = app.tables.matching(identifier: "search-historytableview").element
        
        XCTAssertFalse(searchHistoryTableViewElement.exists)
        XCTAssertTrue(flickrImageCollectionViewElement.exists)
        
        flickrSearchBarElement.tap()
        
        XCTAssertFalse(flickrImageCollectionViewElement.exists)
        XCTAssertTrue(searchHistoryTableViewElement.exists)
    }
    
    
}
