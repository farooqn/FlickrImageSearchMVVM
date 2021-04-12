//
//  FlickrAPI.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 10.04.2021.
//

import Foundation

/// FlickrAPI appends parameters in Flickr APIs and returns using class methods.Contains all API related methods.
class FlickrAPI{
    private static let flickrAPIKey = "11c40ef31e4961acf4f98c8ff4e945d7"
    

    class func flickerPhotosSearchAPI(searchTerm:String)->URL?{
        
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let searchAPI = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrAPIKey)&text=\(encodedSearchTerm)&format=json&nojsoncallback=1"
        guard let flickrURL = URL(string: searchAPI) else {
            return nil
        }
        
        return flickrURL
    }
    
    
    class func photoURLAPI(photo:PhotoModel)->URL?{
        let urlAPI = "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        guard let flickrURL = URL(string: urlAPI) else {
            return nil
        }
        return flickrURL
    }
    
}





