//
//  UPSearchViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import UIKit

final class UPSearchViewComposer{
    
    let httpClient: UPHttpClient
    let navigationController: UINavigationController
    
    init(httpClient: UPHttpClient, naviagtionController: UINavigationController) {
        self.httpClient = httpClient
        self.navigationController = naviagtionController
    }
    
    func start(){
        
        let viewController = UPSearchViewComposer.createHomeView(httpClient: httpClient) as! OutletSearchViewController
        viewController.onOfferSelected = onOfferSelected
        viewController.showOutlet = onOutletSelected
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    private func onOfferSelected(offer: UPOffer){
        guard let id = offer.id else { return }
        let offerDetailComposer = UPOfferDetailComposer(navigationController: navigationController, httpClient: httpClient, offerID: id)
        offerDetailComposer.start()
    }
    
    private func onOutletSelected(outlet: UPOutletListingTableViewCell.Outlet){
        if outlet.isParentOutlet{
            let flow = NewBrandComposer(httpClient: httpClient, navigationController: navigationController)
            flow.start(withListingType: .child(outlet.id, outlet.outletName))
        }else{
            let flow = UPOutletDetailComposer(navigationController: navigationController, httpClient: httpClient, outletID: outlet.id)
            flow.start()
        }
    }
    
    static func createHomeView(httpClient: UPHttpClient) -> UIViewController{
        
        let trendingSearchesRepository = UPTrendingSearchHttpRepository(httpClient: httpClient)
      let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let viewModel = UPOutletSearchViewModel(trendingSearchRespository: trendingSearchesRepository, outletRespository: outletRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletSearch", bundle: storyBoardBundle).instantiateViewController(identifier: "OutletSearchViewController")
        
        return viewController
    }
    
}
