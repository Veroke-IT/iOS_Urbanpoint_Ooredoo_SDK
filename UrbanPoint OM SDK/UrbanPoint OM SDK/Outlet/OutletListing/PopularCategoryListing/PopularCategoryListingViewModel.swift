//
//  PopularCategoryListingViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import Foundation
import CoreLocation

final class UPPopularCategoryViewModel: OutletListingPresenterContract{
  
    let outletRepository: OutletRepository
    var currentLocation: CLLocationCoordinate2D? = nil
    let locationManager: UPLocationManager = UPLocationManager.sharedInstance
    let selectedPopularCategoryID: Int
    
    
    init(outletRepository: OutletRepository,selectedPopularCategoryID: Int){
        self.outletRepository = outletRepository
        self.selectedPopularCategoryID = selectedPopularCategoryID
        locationManager.delegate = self
    }
    
    
    
    func fetchOutletNearby(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int,  completion: @escaping (([UPOutletListingTableViewCell.Outlet],String?)) -> Void) {
        guard let currentLocation else {
            completion(([],"Enable current location"))
            return
        }
        outletRepository.fetchOutlet(param: [.searchOutlets(searchText ?? ""),
                                             .paggingIndex(String(index)),
                                             .sortBy(.nearby),
                                             .popularCategoryID(String(selectedPopularCategoryID)),
                                             .longitude(String(currentLocation.longitude)),
                                             .latitude(String(currentLocation.latitude))
        ]) { result in
            switch result{
            case .success(let data):
                let outlets = data.map { outlet in
                    UPOutletListingTableViewCell.Outlet(id: outlet.id ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.image ?? "")), distance: outlet.distance?.value ?? "", isExpanded: false, offers:  outlet.offers ?? [], isParentOutlet: false)
                }
                completion((outlets,nil))
            case .failure(let error):
                completion(([],error.localizedDescription))
            }
        }
        
    }

    func fetchOutletAlphabatical(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet], String?)) -> Void) {
        outletRepository.fetchOutlet(param:[.popularCategoryID(String(selectedPopularCategoryID)),
                                            .sortBy(.alphabatical),
                                            .paggingIndex(String(index))]) { result in
            switch result{
            case .success(let data):
                let outlets = data.map { outlet in
                    UPOutletListingTableViewCell.Outlet(id: outlet.id ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.image ?? "")), distance: outlet.distance?.value ?? "", isExpanded: false, offers: outlet.offers ?? [], isParentOutlet: false)
                }
                completion((outlets,nil))
            case .failure(let error):
                completion(([],error.localizedDescription))
            }
                                         
        }
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
