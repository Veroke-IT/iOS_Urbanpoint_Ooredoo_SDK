//
//  HomeViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation

struct RecentlyViewedOutlet: Identifiable,Codable{
    var id: Int
    let outletName: String
    let outletLogoURL: String
}

final class UPHomeViewModel{
    
    private let homeService: HomeService
    private(set) var recentlyViewedOutlet: [RecentlyViewedOutlet] = []
    private(set) var nearbyOutlet: [NearbyOutlet] = []
    private(set) var useAgainOffers: [UseAgainOffer] = []
    private(set) var popularCategories: [PopularCategory] = []
    private(set) var categories: [Category] = []
    private(set) var newBrand: [NewBrand] = []
    
    
    init(homeService: HomeService) {
        self.homeService = homeService
    }
    
    func fetchEssentialData(completion: @escaping (String?) -> Void){
        homeService.fetchEssentialHomeData { result in
            switch result{
                case .success(let data):
                    self.nearbyOutlet = data.data.nearbyOutlets
                    self.useAgainOffers = data.data.offerUsedAgain
                    completion(nil)
                case .failure(let error): completion(error.localizedDescription)
            }
        }
    }
    
    func fetchCachedData(completion: @escaping (String?) -> Void){
        homeService.fetchRedisCacheData { result in
            switch result{
            case .success(let data):
                self.popularCategories = data.data.popularCategories
                self.categories = data.data.categories
                self.newBrand = data.data.newBrands
                completion(nil)
            case .failure(let error): completion(error.localizedDescription)
            }
        }
    }
    
    internal func fetchRecentlyViewedOutlets(){
        recentlyViewedOutlet = UserDefaultsRecentlyViewedOutletWrapper.sharedInstance
            .getRecentlyViewedOutlet()
    }
    
}
