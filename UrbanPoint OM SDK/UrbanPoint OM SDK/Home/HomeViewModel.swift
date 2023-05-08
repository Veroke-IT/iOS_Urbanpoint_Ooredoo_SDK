//
//  HomeViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation
import CoreLocation

struct RecentlyViewedOutlet: Identifiable,Codable{
    var id: Int
    let outletName: String
    let outletLogoURL: String
}

final class UPHomeViewModel: UPLocationManagerDelegate{
    
    private let homeService: HomeService
    private(set) var recentlyViewedOutlet: [RecentlyViewedOutlet] = []
    private(set) var nearbyOutlet: [NearbyOutlet] = []
    private(set) var useAgainOffers: [UseAgainOffer] = []
    private(set) var popularCategories: [PopularCategory] = []
    private(set) var categories: [Category] = []
    private(set) var newBrand: [NewBrand] = []
    
    let locationManager: UPLocationManager = UPLocationManager.sharedInstance
    private var currentLocation: CLLocationCoordinate2D? = nil
    
    
    init(homeService: HomeService) {
        self.homeService = homeService
        locationManager.delegate = self
    }
    
    func fetchEssentialData(completion: @escaping (String?) -> Void){
        
        var longitude = ""
        var latitude = ""
        if let currentLocation{
            longitude = String(currentLocation.longitude)
            latitude = String(currentLocation.latitude)
        }
        
        homeService.fetchEssentialHomeData(location: (longitude,latitude)) { result in
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
    
    
    func fetchLocation(completion: @escaping () -> Void){
        
    }
    
    internal func fetchUserLocation(){
         locationManager.startUpdatingLocation()
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation.coordinate
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        debugPrint(error.localizedDescription)
    }
}
