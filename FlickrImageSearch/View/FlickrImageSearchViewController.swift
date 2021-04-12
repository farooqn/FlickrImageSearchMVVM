//
//  ViewController.swift
//  FlickrImageSearch
//
//  Created by Farooq Nasim Ahmad on 10.04.2021.
//

import UIKit

///view class of Flickr Image Search
class FlickrImageSearchViewController: UIViewController {
    var imageSearch = FlickrImageSearchViewModel()
    var searchHistory = SearchHistoryViewModel()
    var storedHistoryList:[String]?
    
    @IBOutlet weak var flickrSearchBar: UISearchBar!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var flickrImageCollectionView: UICollectionView!
    private let photoCellReuseIdentifier = "PhotoCell"
    private let searchCellReuseIdentifier = "SearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Data binding for FlickrImageSearchViewModel
        imageSearch.didUpdateImageSearchView = {[weak self] in
            guard let weakself = self else {return}
            
            DispatchQueue.main.async {
                weakself.flickrImageCollectionView.reloadData()
            }
        }
        
        ///Data binding for fetch photo errors
        imageSearch.didReceiveFetchPhotoError = {(error) in
            //print(error)
            /// do appropriate error handling here
        }
        
        ///Data binding for SearchHistoryViewModel
        searchHistory.didRetreiveSearchHistory = {[weak self] storedHistoryList in
            guard let weakself = self else {return}
            weakself.storedHistoryList = storedHistoryList
            DispatchQueue.main.async {
                weakself.searchHistoryTableView.reloadData()
            }
        }
        
        /// for UI Testing
        flickrSearchBar.accessibilityIdentifier = "flickr-searchbar"
        flickrImageCollectionView.accessibilityIdentifier = "flickr-imagecollectionview"
        searchHistoryTableView.accessibilityIdentifier = "search-historytableview"
    }
    
    ///To update two column layout in transition from portrait to landscape and vice versa
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flickrImageCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - UICollectionView delegate methods to display photos

extension FlickrImageSearchViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:widthPerItem)
    }
}

extension FlickrImageSearchViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageSearch.searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as! FlickrImageCell
        DispatchQueue.main.async {
            cell.imageView.image = UIImage(systemName: "photo")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoURL = imageSearch.photoURLs[indexPath.row]
        imageSearch.fetchPhoto(photoURL: photoURL, indexPath: indexPath) { (image, index) in
            ///display image in correspodning cell with correct IndexPath
            DispatchQueue.main.async {
                if let currentCell = collectionView.cellForItem(at: index) {
                    (currentCell as? FlickrImageCell)!.imageView.image = image
                }
            }
        }
    }
    
    
}


// MARK: - UITableView delegate methods to display search history
extension FlickrImageSearchViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedHistoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = storedHistoryList?[indexPath.row] ?? ""
        return cell
    }
    
    
}

extension FlickrImageSearchViewController:UITableViewDelegate{
    
}

// MARK: - UISearchBar delegate methods
extension FlickrImageSearchViewController:UISearchBarDelegate{
    ///show photos in collection view and hide search history and dismiss keyboard when search button is tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async{
            self.flickrImageCollectionView.isHidden = false
            self.searchHistoryTableView.isHidden = true
            searchBar.searchTextField.resignFirstResponder()
        }
        
        ///remove relevant entries for last search from corresponding arrays in viewModel
        imageSearch.clearPhotosURL()
        
        ///get search term from searhBar and store in search history and bring photo list
        if let searchTerm = searchBar.text{
            searchHistory.storeSearchHistory(searchTerm: searchTerm)
            imageSearch.fetchPhotoList(withSearchTerm:searchTerm)
        }
    }
    
    ///show table view to display stored search history when search bar is tapped
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchHistory.retreiveSearchHistory()
        DispatchQueue.main.async{
            self.flickrImageCollectionView.isHidden = true
            self.searchHistoryTableView.isHidden = false
        }
        
        return true
    }
    
    ///show photos list if search bar is cancelled and dismiss keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async{
            self.flickrImageCollectionView.isHidden = false
            self.searchHistoryTableView.isHidden = true
            searchBar.searchTextField.resignFirstResponder()
        }
    }
}

