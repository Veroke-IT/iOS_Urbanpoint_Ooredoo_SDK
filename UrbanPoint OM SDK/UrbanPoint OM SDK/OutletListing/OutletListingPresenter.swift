//
//  OutletListingPresenter.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import Foundation

final class OutletListingPresenter{
    
    let outletRepository: OutletRepository
    
    
    init(outletRepository: OutletRepository) {
        self.outletRepository = outletRepository
    }
    
    func fetchOutlet(completion: @escaping ([Outlet]) -> Void){
        outletRepository.fetchOutlet(param: [:]) { result in
            switch result{
            case .success(let data):
                completion(data)
            case .failure(_):
                completion([])
            }
        }
    }
    
}
