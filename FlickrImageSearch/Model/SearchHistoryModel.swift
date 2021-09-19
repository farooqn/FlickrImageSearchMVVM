//
//  SearchHistoryModel.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 11.04.2021.
//  Git repository change in head

import Foundation

/// SearchHistoryModel stores search history in an array and finally in UserDefaults. It also retreives history.
class SearchHistoryModel{
    var localSearchHistory = [String]()
    let userDefault = UserDefaults.standard
    private let searchKey = "searchHistory"
    
    init() {
        if let historyData = userDefault.value(forKey: searchKey) {
            localSearchHistory.append(contentsOf: (historyData as! [String]))
        }
    }
    
    func storeSearchHistory(searchTerm:String){
        localSearchHistory.append(searchTerm)
        userDefault.setValue(localSearchHistory, forKey: searchKey)
    }
    
    func retreiveSearchHistory()->[String]?{
        guard let historyData = userDefault.value(forKey: searchKey) else {return nil}
        return (historyData as! [String])
    }
}
