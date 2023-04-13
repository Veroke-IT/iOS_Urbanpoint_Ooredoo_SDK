//
//  OutletListingPresenter.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import Foundation
import CoreLocation


final class OutletListingPresenter:UPLocationManagerDelegate{
 
    

    struct Outlet: Decodable{
        let outletID: Int
        let outletName: String
        let outletImage: String
        let isNewBrand: Bool
        let outletDistance: String
        let offers: [UPOffer]
    }

    let locationManager: UPLocationManager = UPLocationManager.sharedInstance
    let outletRepository: OutletRepository
    let parentID: String?
    var currentLocation: CLLocationCoordinate2D? = nil
    
    init(outletRepository: OutletRepository,parentID: String? = nil) {
        self.parentID = parentID
        self.outletRepository = outletRepository
        locationManager.delegate = self
    }
    
    func fetchOutletNearby(index: Int,sortCondition: OutletRepositoryParam.Sort,completion: @escaping (([Outlet],String?)) -> Void){
        if let currentLocation{
            outletRepository.fetchOutlet(param:[.childOutlets(parentID),
                                                .sortBy(sortCondition),
                                                .paggingIndex(String(index)),
                                                .longitude(String(currentLocation.longitude)),
                                                .latitude(String(currentLocation.latitude))])
            { result in
                switch result{
                case .success(let data):
                      let outlets = data.map({ outlet in
                          OutletListingPresenter.Outlet(outletID: outlet.id, outletName: outlet.name, outletImage: outlet.image, isNewBrand: outlet.isnewBrand == "1", outletDistance: outlet.distance ?? "", offers: outlet.offers)
                        })
                    completion((outlets,nil))
                case .failure(let error):
                    completion(([],error.localizedDescription))
                }
            }
        }
    }
    
    func fetchOutlet(index: Int,sortCondition: OutletRepositoryParam.Sort,completion: @escaping (([Outlet],String?)) -> Void){
        
       
        
        outletRepository.fetchOutlet(param:[.childOutlets(parentID),.sortBy(sortCondition),.paggingIndex(String(index))]) { result in
            switch result{
            case .success(let data):
                  let outlets = data.map({ outlet in
                      OutletListingPresenter.Outlet(outletID: outlet.id, outletName: outlet.name, outletImage: outlet.image, isNewBrand: outlet.isnewBrand == "1", outletDistance: outlet.distance ?? "", offers: outlet.offers)
                    })
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
