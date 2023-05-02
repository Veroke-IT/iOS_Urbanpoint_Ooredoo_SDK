//
//  UPCataegoryViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/13/23.
//

import Foundation
import CoreLocation

final class UPCategoryViewModel: OutletListingPresenterContract{
   
    var currentLocation: CLLocationCoordinate2D?
    let homeService: HomeService
    let outletRepository: OutletRepository
    let selectedCategoryID: Int
    var selectedCateogoryName: String? = ""
    var categories: [UPCategory] = []
    let locationManager: UPLocationManager = UPLocationManager.sharedInstance
    var selectedCollectionID: Int? = nil
    
    
    init(homeService: HomeService, outletRepository: OutletRepository, selectedCategoryID: Int) {
        self.homeService = homeService
        self.outletRepository = outletRepository
        self.selectedCategoryID = selectedCategoryID
        locationManager.delegate = self
    }
    
    internal func fetchCategories(completion: @escaping (String?) -> Void){
        homeService.fetchHomeApiDetail(cateogoryID: selectedCategoryID) { result in
            switch result {
            case .success(let success):
                
                self.categories = success.data.collection
                self.selectedCollectionID = self.categories.first?.id
                self.selectedCateogoryName = self.categories.first?.name
                completion(nil)
            case .failure(let failure):
                completion(failure.localizedDescription)
            }
        }
    }
    
    func fetchOutletNearby(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet], String?)) -> Void) {
        if let currentLocation{
            outletRepository.fetchOutlet(param:[.categoryID(String(self.selectedCategoryID)),
                                                .collectionID(String(collectionID ?? -1)),
                                                .sortBy(.nearby),
                                                .paggingIndex(String(index)),
                                                .longitude(String(currentLocation.longitude)),
                                                .latitude(String(currentLocation.latitude))])
            { result in
                switch result{
                case .success(let data):
                      let outlets = data.map({ outlet in
                          var distance = outlet.distance?.value.getNumberWithoutDecimal() ?? " "
                          if let dist = Int(distance){
                              distance = "within \(dist/1000) km"
                          }else{
                              distance = ""
                          }
                          return UPOutletListingTableViewCell.Outlet(id: outlet.id ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: distance, isExpanded: false, offers: outlet.offers ?? [], isParentOutlet: false)
                        })
                    completion((outlets,nil))
                case .failure(let error):
                    completion(([],error.localizedDescription))
                }
            }
        }
    }
    
    func fetchOutletAlphabatical(searchText: String?, categoryID: Int?, collectionID: Int?, index: Int, completion: @escaping (([UPOutletListingTableViewCell.Outlet], String?)) -> Void) {
        outletRepository.fetchParentOutlet(param:[.categoryID(String(self.selectedCategoryID)),
                                            .collectionID(String(collectionID ?? -1)),
                                            .sortOrder(.asc),
                                            .sortBy(.name),
                                            .paggingIndex(String(index))]) { result in
            switch result{
            case .success(let data):
                let outlets = data.map { outlet in
                    let offers = ((outlet.outlets?.count ?? 0) > 1) ? (outlet.outlets?.first?.offers ?? []) : []
                    let description = (offers.count == 0) ? "Multiple Locations" : (outlet.outlets?.first?.address ?? "")
                    return UPOutletListingTableViewCell.Outlet(id:  outlet.id  ?? -1, outletName: outlet.name ?? "", image: URL(string: imageBaseURL + (outlet.logo ?? "")), distance: description, isExpanded: false, offers: offers, isParentOutlet: offers.count == 0)
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
