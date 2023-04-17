//
//  OfferDetailComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import Foundation
import UIKit
final class UPOfferDetailComposer{
    
    let navigationController: UINavigationController
    let httpClient: UPHttpClient
    private let offerID: Int
    
    init(navigationController: UINavigationController, httpClient: UPHttpClient, offerID: Int) {
        self.navigationController = navigationController
        self.httpClient = httpClient
        self.offerID = offerID
        
    }
    
    internal func start(){
        let offerDetailVC = UPOfferDetailComposer.createOfferDetailView(offerID: offerID, httpClient: httpClient)
        offerDetailVC.TermsAndConditions = onTermsAndServiceTapped
        navigationController.present(offerDetailVC, animated: true)
    }
    
    private func onTermsAndServiceTapped(){
        if let url = URL(string: termsAndServiceURL){
            let webViewComposer = UPWebViewComposer(navigationController: navigationController)
            webViewComposer.start(withURL: url)
        }
    }
    
    private func onRedeemOfferTapped(){}
    
    
    static func createOfferDetailView(offerID id: Int,httpClient: UPHttpClient) -> OfferDetailViewController{
        let offerRepository = URLSessionOfferRepository(httpClient: httpClient)
        let viewModel = OfferDetailViewModel(offerID: id,
                                             offerRepository: offerRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "Offer", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        viewController.offerDetailViewModel = viewModel
        return viewController
    }
    
    
}
