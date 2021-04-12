//
//  NetworkOps.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 10.04.2021.
//

import Foundation
import UIKit


enum FetchPhotoModelError: Error {
    //if the error comes from server
    case serverError
    // if data comes but it is corrupted
    case invalidDataError
    //no error found
    case none
}

/// FlickrNetworkOps is a class to handle all network communication related to Flickr APIs
class FlickrNetworkOps{
    private let session = URLSession.shared
    
    /// stores cached images against image url as key
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    
    /// fetchPhotoList brings list of photos using flickerPhotosSearchAPI given in FlickrAPI.swift
    /// - Parameters:
    ///   - searchTerm: specific term to search
    ///   - completion: Callback for PhotoModel and can also takes error that is not handled yet.
    func fetchPhotoList(withSearchTerm searchTerm: String, completion: @escaping ([PhotoModel]?, Error?) -> ()){
        
        ///get search API with given search term
        guard let flickrURL =  FlickrAPI.flickerPhotosSearchAPI(searchTerm: searchTerm) else {
            return
        }
        
        let request = URLRequest(url: flickrURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //decode json data and pass PhotoModel array to callBack
            DispatchQueue.main.async {
                guard let data = data,
                      let photosListData = try? JSONDecoder().decode(FlickrPhotosListModel.self, from: data) else {
                    completion(nil,nil)//handle error approprietly
                    return
                }
                completion(photosListData.photos.photo,nil)
            }
        }
        task.resume()
        
    }
    
    /// Return cached images for url key
    /// - Parameter url: url key for which images are stored in cache
    /// - Returns: cached image if available
    func image(url: URL) -> UIImage? {
        return cachedImages.object(forKey: url as NSURL)
    }
    
    
    
    /// fetchPhoto brings an image from given url. it first checks if image is available in cached images if not it downloads from server and stores in cached images as well as passes to callback.
    /// - Parameters:
    ///   - photoURL: url of photo
    ///   - indexPath: indexpath of cell to display correct photo
    ///   - completion: callback for error in case of failure or image in case of success
    func fetchPhoto(photoURL: URL, indexPath: IndexPath , completion: @escaping (UIImage?,IndexPath?,FetchPhotoModelError) -> ()){
        
        
        /// check if image is available for given url in cached images
        if let cachedImage = image(url: photoURL) {
            DispatchQueue.main.async {
                completion(cachedImage, indexPath, .none)
            }
            return
        }
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                //check for error returned by server
                if (error != nil) {
                    completion(nil,nil,.serverError)
                }else{
                    ///if data is not nil or invalid create image with data or return error
                    guard let data = data, let image = UIImage(data: data) else {
                        completion(nil,nil,.invalidDataError)
                        return
                    }
                    
                    ///store image in cached images
                    self.cachedImages.setObject(image, forKey: photoURL as NSURL)
                    ///pass image for corresponding indexpath to callback
                    completion(image, indexPath, .none)
                }}
            
        }
        
        task.resume()
    }
    
    
}
