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
        let outletImage: URL?
        let outletLongitude: Double
        let outletLatitude: Double
        let outletPhonenNumber: [String]
        let outletMenu: [UPOutlet.OutletMenu]
        let bannerImages: [URL?]
        
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
                    self.outlet = self.convertUPOutletToOutlet(outlet: data)
                    
                    
                    completion(nil)
                }
                else{
                    completion("Oops something went wrong")
                }
            case .failure(let failure):
                completion(failure.localizedDescription)
            }
        }
    }
    
    private func convertUPOutletToOutlet(outlet: UPOutlet) -> UPOutletDetailViewModel.Outlet{
        var bannerImages = [URL(string: imageBaseURL + ( outlet.image ?? ""))]
        
        if let images = outlet.outletImages, !images.isEmpty{
            bannerImages = images.compactMap({ image in
                URL(string:  imageBaseURL + (image.file ?? ""))
            })
        }
        
        return UPOutletDetailViewModel.Outlet(id: outlet.id ?? -1 , outletName: outlet.name ?? "" , outletDescription: outlet.description ?? "" , outletAddress: outlet.address ?? "", outletOffers: outlet.offers ?? [], outletTimings: outlet.timings ?? "" , outletImage: URL(string: imageBaseURL + (outlet.image ?? "")), outletLongitude: outlet.longitude ?? 0, outletLatitude: outlet.latitude ?? 0, outletPhonenNumber: [outlet.phones ?? ""], outletMenu: outlet.outletMenu ?? [], bannerImages: bannerImages)
    }
    
}
