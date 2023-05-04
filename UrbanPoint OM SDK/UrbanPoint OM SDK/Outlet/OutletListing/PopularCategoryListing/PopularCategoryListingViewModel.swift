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
                    var distance = outlet.distance?.value.getNumberWithoutDecimal() ?? " "
                    if let dist = Int(distance){
                        distance = "within \(dist/1000) km"
                    }else{
                        distance = ""
                    }
                    return UPOutletListingTableViewCell.Outlet(id: outlet.id ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: distance, isExpanded: false, offers:  outlet.offers ?? [], isParentOutlet: false)
                }
                completion((outlets,nil))
            case .failure(let error):
                completion(([],error.localizedDescription))
            }
        }
        
    }

    func fetchOutletAlphabatical(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet], String?)) -> Void) {
        outletRepository.fetchParentOutlet(param:[.popularCategoryID(String(selectedPopularCategoryID)),
                                                  .sortBy(.name),
                                                  .sortOrder(.asc),
                                            .paggingIndex(String(index))]) { result in
            switch result{
            case .success(let data):
                let outlets = data.map { outlet in
                    let offers = ((outlet.totalOutlets ?? 0 ) > 1 ) ? [] : (outlet.outlets?.first?.offers ?? [])
                    let description = (offers.count == 0) ? "Multiple Locations" : (outlet.outlets?.first?.address ?? "")
                    let outletID = offers.count == 0 ? outlet.id ?? -1 : (outlet.outlets?.first?.id ?? -1)
                   
                    return UPOutletListingTableViewCell.Outlet(id:  outletID, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: description, isExpanded: false, offers: offers, isParentOutlet: offers.count == 0)
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
