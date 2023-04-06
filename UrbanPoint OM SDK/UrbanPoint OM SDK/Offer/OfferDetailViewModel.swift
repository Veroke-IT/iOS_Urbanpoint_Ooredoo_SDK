//
//  OfferDetailViewModel.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/4/23.
//

import Foundation

final class OfferDetailViewModel{
    
    private let offerID: Int?
    private(set) var offer: OfferDetailApiResponse.Offer? = nil
    private let offerRepository: OfferRepository
    
    init(offerID: Int? = nil,offerRepository: OfferRepository) {
        self.offerID = offerID
        self.offerRepository = offerRepository
    }
    
    func fetchOfferDetail(completion: @escaping (String?) -> Void){
        guard let offerID else {
            completion("Oops something went wrong.")
            return
        }
        offerRepository.fetchOffer(withID: offerID) { result in
            switch result {
            case .success(let data):
                self.offer = data
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
}
