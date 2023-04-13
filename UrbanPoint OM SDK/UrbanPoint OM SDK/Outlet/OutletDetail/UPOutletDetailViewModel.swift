//
//  UPOutletDetailViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/7/23.
//

import Foundation

final class UPOutletDetailViewModel{
    
    struct Outlet: Identifiable{
     
        let id: Int
        let outletName: String
        let outletDescription: String
        let outletAddress: String
        let outletOffers: [UPOffer]
        let outletTimings: String
        let outletImage: URL
        let outletLongitude: CGFloat
        let outletLatitude: CGFloat
        let outletPhonenNumber: [String]
        let outletMenu: URL?
        let bannerImages: [URL]
        
    }
    
    private(set) var outletImages: [URL] = []
    private(set) var outlet: Outlet? = nil
    
    private let outletID: Int
    private let outletRepository: OutletRepository
    
    init(outletID: Int, outletRepository: OutletRepository) {
        self.outletID = outletID
        self.outletRepository = outletRepository
    }
    
    internal func fetchOutlet(completion:@escaping (String?) -> Void){
        outletRepository.fetchOutlet(param: [.outletDetail(String(outletID))]) { result in
            switch result {
            case .success(let data):
                if let data = data.first{
                    self.outlet = UPOutletDetailViewModel.Outlet(id: data.id, outletName: data.name, outletDescription: data.description, outletAddress: data.address, outletOffers: data.offers, outletTimings: data.outletTiming, outletImage: URL(string: imageBaseURL + data.image)!, outletLongitude: data.longitude, outletLatitude: data.latitude, outletPhonenNumber: [data.phones], outletMenu: URL(string: data.menuCard), bannerImages: data.outletImages?.compactMap({ URL(string: imageBaseURL + $0.file )
                    }) ?? [])
                    completion(nil)
                }else{
                    completion("Oops something went wrong")
                }
            case .failure(let failure):
                completion(failure.localizedDescription)
            }
        }
    }
    
}
