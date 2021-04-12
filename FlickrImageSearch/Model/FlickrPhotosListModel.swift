//
//  FlickrImageDataModel.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 10.04.2021.
//

import Foundation


/// Model of required photo parameters
struct PhotoModel:Decodable{
    var id:String
    var secret:String
    var server:String
    var farm:Int
}


/// Model for json returned by flickerPhotosSearchAPI for required parameters
struct FlickrPhotosListModel:Decodable{
    struct Photos:Decodable{
        var photo:[PhotoModel]
    }
    let photos:Photos
}
