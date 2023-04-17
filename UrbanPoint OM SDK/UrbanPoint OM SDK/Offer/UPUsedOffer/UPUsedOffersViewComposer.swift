//
//  UPUsedOffersViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit

final class UPUsedOfferViewComposer{
    
    static func createUsedOfferView(httpClient: UPHttpClient) -> UIViewController{
        let offerRepository = URLSessionOfferRepository(httpClient: httpClient)
        let viewModel = UPUsedOfferViewModel(offerRepository: offerRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "UPUsedOffer", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPUsedOfferViewController") as! UPUsedOfferViewController
        viewController.viewModel = viewModel
        return viewController
        
    }
    
    
}
