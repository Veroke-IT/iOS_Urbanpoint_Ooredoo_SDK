//
//  UPUsedOffersViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit

final class UPUsedOfferViewComposer{
    
    let httpClient: UPHttpClient
    let navigationController: UINavigationController
    
    init(httpClient: UPHttpClient, navigationController: UINavigationController) {
        self.httpClient = httpClient
        self.navigationController = navigationController
    }
    
    func start(){
        let offerRepository = URLSessionOfferRepository(httpClient: httpClient)
        let viewController = UPUsedOfferViewComposer.createUsedOfferView(offerRepository: offerRepository) as! UPUsedOfferViewController
        viewController.onBackButtonTapped = onBackButtonTapped
        viewController.viewModel = UPUsedOfferViewModel(offerRepository: offerRepository)
        viewController.showOfferDetail = navigateToOfferDetail
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func onBackButtonTapped(){
        navigationController.popViewController(animated: true)
    }
    
    private func navigateToOfferDetail(id: Int){
        let offerDetailComposer = UPOfferDetailComposer(navigationController: navigationController, httpClient: httpClient, offerID: id)
        offerDetailComposer.start()
    }
    
    
    static func createUsedOfferView(offerRepository: OfferRepository) -> UIViewController{
        var viewControllerName = "UPUsedOfferViewController"
        if appLanguage == .arabic{
            viewControllerName += "_ar"
        }
        let viewModel = UPUsedOfferViewModel(offerRepository: offerRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "UPUsedOffer", bundle: storyBoardBundle).instantiateViewController(withIdentifier: viewControllerName) as! UPUsedOfferViewController
        viewController.viewModel = viewModel
        return viewController
        
    }
    
    
}
