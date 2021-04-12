//
//  SearchHistoryViewModel.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 11.04.2021.
//

import Foundation

class SearchHistoryViewModel{
    var searchHistory = SearchHistoryModel()
    var didRetreiveSearchHistory: (([String]) -> Void)?
    
    func storeSearchHistory(searchTerm:String){
        searchHistory.storeSearchHistory(searchTerm: searchTerm)
    }
    
    func retreiveSearchHistory(){
        guard let historyList = searchHistory.retreiveSearchHistory() else {return}
        didRetreiveSearchHistory?(historyList)
    }
}
