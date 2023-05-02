//
//  NearbyOutletListingViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import Foundation
import CoreLocation

final class NearbyListingViewModel: OutletListingPresenterContract{

    
    
    var nearbyBrands: [UPOutlet] = []
    var alphabaticalBrands: [UPParentOutlet] = []
    let outletRepository: OutletRepository
    var currentLocation: CLLocationCoordinate2D? = nil
    let locationManager: UPLocationManager = UPLocationManager.sharedInstance
    
    init(outletRepository: OutletRepository) {
        self.outletRepository = outletRepository
        locationManager.delegate = self
    }
    
    
    func fetchOutletNearby(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int,  completion: @escaping (([UPOutletListingTableViewCell.Outlet],String?)) -> Void) {
        guard let currentLocation else {
            completion(([],"Enable current location"))
            return
        }
        outletRepository.fetchNearbyOutlets(param: [.searchOutlets(searchText ?? ""),
                                                    .paggingIndex(String(index)),
                                                    .sortBy(.nearby),
                                                    .longitude(String(currentLocation.longitude)),
                                                    .latitude(String(currentLocation.latitude))
        ]) { result in
            switch result{
            case .success(let data):
                let outlets = data.map { outlet in
                    var distance = outlet.distance?.value.getNumberWithoutDecimal() ?? " "
                    if let dist = Int(distance){
                        distance = "within \(dist/1000) km"
                    }else{
                        distance = ""
                    }
                    return UPOutletListingTableViewCell.Outlet(id:  outlet.id  ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: distance, isExpanded: false, offers: outlet.offers ?? [], isParentOutlet: false)
                }
                completion((outlets,nil))
            case .failure(let error):
                completion(([],error.localizedDescription))
            }
        }
        
    }
    
    func fetchOutletAlphabatical(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet], String?)) -> Void) {
        
        outletRepository.fetchNearbyOutlets(param: [.searchOutlets(searchText ?? ""),
                                                    .paggingIndex(String(index)),
                                                    .sortBy(.alphabatical)
        ]) { result in
            switch result{
            case .success(let data):
                let outlets = data.map { outlet in
                    UPOutletListingTableViewCell.Outlet(id:  outlet.id  ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: outlet.address ?? "", isExpanded: false, offers: outlet.offers ?? [], isParentOutlet: false)
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
