//
//  UPRedeemOfferViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/13/23.
//

import Foundation


final class UPRedeemOfferViewModel{
    
    struct RedeemOfferViewModel{
        let outletName: String
        let offerDetails: String
        let offerID: Int
        let outletID: Int
        let outletImage: URL?
        
    }
    
    let offerRepository: OfferRepository
    let offerData: RedeemOfferViewModel
    
    init(offerRepository: OfferRepository,offerData: RedeemOfferViewModel) {
        self.offerRepository = offerRepository
        self.offerData = offerData
    }
    
    internal func redeemOffer(pin: String, completion:@escaping ((String?,String?)) -> Void){
        let redeemOfferRequest = RedeemOfferRequest(pin: pin, outletID: String(offerData.outletID), offerID: String(offerData.offerID))
        offerRepository.redeemOffer(offerData: redeemOfferRequest) { result in
            switch result {
            case .success(let response):
                completion((response.phone,nil))
            case .failure(let failure):
                completion((nil,failure.localizedDescription))
            }
        }
    }
    
}
