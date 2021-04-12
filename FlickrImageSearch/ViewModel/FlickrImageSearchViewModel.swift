//
//  FlickrImageSearchViewModel.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 10.04.2021.
//

import Foundation
import UIKit


/// Error list for corresponding errors from network services in view model
enum FetchPhotoViewModelError: Error {
    //if the error comes from server
    case serverError
    // if data comes but it is corrupted
    case invalidDataError
}

/// ViewModel class Flickr Image Search
class FlickrImageSearchViewModel{
    var networkOps = FlickrNetworkOps()
    var didUpdateImageSearchView: (() -> Void)?
    var didReceiveFetchPhotoError: ((FetchPhotoViewModelError) -> Void)?
    
    var photoURLs = [URL]()
    
    ///Computed property to store search results for each PhotoModel in an array
    private(set) var searchResult: [PhotoModel] = [PhotoModel]() {
        didSet {
            didUpdateImageSearchView?()
        }
    }
    
    /// fetchPhotoList call network services to bring list of PhotoModel and converts them in corresponding URL and stores in photoURLs array. Error handling is yet to be implemented.
    /// - Parameter searchTerm: specific term to search
    func fetchPhotoList(withSearchTerm searchTerm: String)->Void{
        networkOps.fetchPhotoList(withSearchTerm: searchTerm) {[weak self] (photosModels, error) in
            guard let weakSelf = self else {return}
            guard let photosModel = photosModels else {return}
            
            weakSelf.searchResult.append(contentsOf: photosModel)
            for item in weakSelf.searchResult{
                if let url = FlickrAPI.photoURLAPI(photo: item) {
                    weakSelf.photoURLs.append(url)
                }
            }
            
            //print(weakSelf.searchResult)
        }
    }
    
    /// fetchPhoto passes image to call back received from network service for give url. It also passes error.
    /// - Parameters:
    ///   - photoURL: url of the photo
    ///   - indexPath:indexpath of cell to display correct photo
    ///   - completion: callback image in case of success
    func fetchPhoto(photoURL: URL, indexPath: IndexPath , completion: @escaping (UIImage,IndexPath) -> ()){
        networkOps.fetchPhoto(photoURL: photoURL, indexPath: indexPath) {[weak self] (image, index, error) in
            guard let weakSelf = self else {return}
            ///Check for error in case of non pass image and corresponding index path to callback
            switch error {
            case .serverError:
                weakSelf.didReceiveFetchPhotoError?(.serverError)
            case .invalidDataError:
                weakSelf.didReceiveFetchPhotoError?(.invalidDataError)
            case .none:
                /// Forced unwrapped becasue can never be nil in case of no error
                completion(image!,index!)
                
            }
        }
    }
    
    
    /// clear photos url and search results if a new search is made
    func clearPhotosURL(){
        searchResult.removeAll()
        photoURLs.removeAll()
    }
}
