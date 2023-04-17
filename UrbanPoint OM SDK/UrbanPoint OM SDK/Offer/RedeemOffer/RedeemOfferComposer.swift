//
//  RedeemOfferComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import UIKit

final class RedeemOfferComposer{
    
    let navigationController: UINavigationController
    let httpClient: UPHttpClient
    private let offerData: UPRedeemOfferViewModel.RedeemOfferViewModel
    
    init(navigationController: UINavigationController, httpClient: UPHttpClient, offerData: UPRedeemOfferViewModel.RedeemOfferViewModel) {
        self.navigationController = navigationController
        self.httpClient = httpClient
        self.offerData = offerData
    }
    
    func start(){
        let offerRepository = URLSessionOfferRepository(httpClient: httpClient)
        let viewController = RedeemOfferComposer.createRedeemOfferView() as! UPRedeemOfferViewController
        let viewModel = UPRedeemOfferViewModel(offerRepository: offerRepository, offerData: offerData)
        viewController.viewModel = viewModel
        viewController.onBackButtonTapped = onBackButtonTapped
        viewController.goToOutlet = goToOutlet
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func goToOutlet(){
        let outletDetailComposer = UPOutletDetailComposer(navigationController: navigationController, httpClient: httpClient, outletID: offerData.outletID)
        navigationController.popViewController(animated: false)
        outletDetailComposer.start()
    }
    
    private func onBackButtonTapped(){
        navigationController.popViewController(animated: true)
    }
    

    static func createRedeemOfferView() -> UIViewController{
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "RedeemOffer", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPRedeemOfferViewController")
      return viewController
    }
    
    
}
