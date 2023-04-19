//
//  UPUsedOfferViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import Foundation

final class UPUsedOfferViewModel{
    
    private let offerRepository: OfferRepository
    private(set) var offers: [UPOffer] = []
    
    init(offerRepository: OfferRepository) {
        self.offerRepository = offerRepository
    }
    
    internal func fetchUsedOffer(index: Int, completion: @escaping (String?) -> Void){
        offerRepository.fetchUsedOffer(index: index) { result in
            switch result {
            case .success(let data):
                if index == 1{
                    self.offers = []
                }
                self.offers.append(contentsOf: data)
               
                completion(nil)
            case .failure(let failure):
                completion(failure.localizedDescription)
            }
        }
    }
    
}
