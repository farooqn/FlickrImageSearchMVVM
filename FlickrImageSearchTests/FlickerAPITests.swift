//
//  FlickerAPITests.swift
//  FlickrImageSearchTests
//
//  Created by Farooq Nasim Ahmad on 11.04.2021.
//

import XCTest
@testable import FlickrImageSearch

class FlickerAPITests: XCTestCase {
    var sut:FlickrAPI?
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testFlickerPhotosSearchAPI() throws {
        let url =   URL(string:"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=11c40ef31e4961acf4f98c8ff4e945d7&text=Apple&format=json&nojsoncallback=1")
        let outputURL = FlickrAPI.flickerPhotosSearchAPI(searchTerm:"Apple")
        XCTAssertEqual(url, outputURL,"invalid API string")
    }
    
    func testPhotoURLAPI() throws {
        let url = URL(string:"https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")
        let model = PhotoModel(id:"23451156376" , secret:"8983a8ebc7", server: "578", farm: 1)
        let outputURL = FlickrAPI.photoURLAPI(photo: model)
        XCTAssertNotNil(outputURL,"invalid url")
        XCTAssertEqual(url, outputURL ?? URL(string:""),"invalid API string")
    }
    
    
}
