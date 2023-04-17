//
//  NewBrandViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import Foundation
import CoreLocation



final class UPNewBrandViewModel: OutletListingPresenterContract{
   
    let outletRepository: OutletRepository
    var currentLocation: CLLocationCoordinate2D? = nil
    let locationManager: UPLocationManager = UPLocationManager.sharedInstance
    
    
    init(outletService: OutletRepository) {
        self.outletRepository = outletService
        locationManager.delegate = self
    }
    
    func fetchOutletNearby(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet],String?)) -> Void) {
        
        guard let currentLocation else {
            completion(([],nil))
            return
        }
        
        outletRepository.fetchNewBrandsNearby(param: [.paggingIndex(String(index)),
                                                   .searchOutlets(searchText ?? ""),
                                                   .longitude(String(currentLocation.longitude)),
                                                   .latitude(String(currentLocation.latitude))]) { result in
                                                       switch result {
                                                       case .success(let data):
                                                           let outlets = data.map { outlet in
                                                               UPOutletListingTableViewCell.Outlet(id:  outlet.id  ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.image ?? "")), distance: outlet.distance?.value ?? "", isExpanded: false, offers: outlet.offers ?? [], isParentOutlet: false)
                                                           }
                                                         completion((outlets,nil))
                                                       case .failure(let error):
                                                           completion(([],error.localizedDescription))
                                                       }
            
        }
        
    }
    
    func fetchOutletAlphabatical(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet],String?)) -> Void) {
        outletRepository.fetchNewBrandsAlphabatical(param: [.paggingIndex(String(index)),
                                                            .searchOutlets(searchText ?? "")]) { result in
                                                             switch result {
                                                             case .success(let data):
                                                                 let tableOutlets = data.map { outlet in
                                                                     
                                                                     let offers = ((outlet.outlets?.count ?? 0) > 1) ? (outlet.outlets?.first?.offers ?? []) : []
                                                                     
                                                                     return UPOutletListingTableViewCell.Outlet(id:  outlet.id  ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: "", isExpanded: false, offers: offers, isParentOutlet: offers.count == 0)
                                                                 }
                                                                 completion((tableOutlets,nil))
                                                             case .failure(let error):
                                                                 completion(([],error.localizedDescription))
                                                             }
                                                         }
   //     (outlet.outlets?.count ?? 0) > 1 ? [] : (outlet.outlets?.first?.offers ?? [])
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
