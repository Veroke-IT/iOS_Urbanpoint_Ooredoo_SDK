//
//  OutletSearchViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import Foundation

final class UPOutletSearchViewModel{
   
    
    private(set) var trendingSearches: [TrendingSearchesResponse.TrendingSearch] = []
    private(set) var storedSearches: [String] = []
    private let trendingSearchRespository: UPTrendingSearchRepository
    private let outletRespository: OutletRepository
    private(set) var totalPages: Int = 5
    internal var searchText: String = ""
    private(set) var outlets: [UPOutletListingTableViewCell.Outlet] = []
    private(set) var autoCompleteOffers: [String] = []
    private(set) var offersSearchDataTask: UPHttpTask? = nil
    
    init(trendingSearchRespository: UPTrendingSearchRepository, outletRespository: OutletRepository) {
        self.trendingSearchRespository = trendingSearchRespository
        self.outletRespository = outletRespository
    }
    
    internal func fetchTrendingSearches(completion:@escaping (Bool) -> Void){
        trendingSearchRespository.fetchTrendingSearches { result in
            switch result {
            case .success(let data):
                self.trendingSearches = data.data
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    internal func deleteStoredSearch(_ string: String){
        trendingSearchRespository.deleteStoredSearch(searchString: string)
    }
    
    internal func fetchStoredSearches(searchText: String,completion:@escaping () -> Void){
        trendingSearchRespository.fetchStoredSearches {[weak self] data in
            self?.storedSearches = data.filter({ $0.contains(searchText)})
            completion()
        }
    }
    
    internal func addToStoredSearches(searchText: String){
        trendingSearchRespository.addSearchToStoredSearches(searchText: searchText)
    }
    
    internal func fetchOutlet(index: Int, completion:@escaping (String?) -> Void){
        outletRespository.fetchOutlet(param: [.searchOutlets(searchText)]) {[weak self] result in
            
            guard let strongSelf = self else {
                completion("Oops something went wrong")
                return
            }
            if index == 1 { strongSelf.outlets = [] }
            strongSelf.trendingSearchRespository.addSearchToStoredSearches(searchText: strongSelf.searchText)
            switch result {
            case .success(let data):
                self?.outlets.append(contentsOf: data.map({ outlet in
                    UPOutletListingTableViewCell.Outlet(id: outlet.id ?? -1, outletName: outlet.name ?? "", image: URL(string:  imageBaseURL + (outlet.image ?? "")), distance:outlet.address ?? "", isExpanded: false, offers: outlet.offers ?? [], isParentOutlet: false)
                    
                }))
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    internal func fetchAutoCompleteOffers(completion:@escaping () -> Void){
        offersSearchDataTask?.cancel()
        offersSearchDataTask = trendingSearchRespository.fetchOffersTag(searchText: searchText) { result in
            switch result {
            case .success(let success):
                self.autoCompleteOffers = success
                completion()
            case .failure(let error):
                debugPrint(error)
                break
            }
        }
    }
}


