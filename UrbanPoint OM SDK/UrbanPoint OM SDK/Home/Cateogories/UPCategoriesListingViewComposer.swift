//
//  UPCategoriesListingViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/15/23.
//

import UIKit


final class UPCategoriesListingViewComposer{
    
    let navigationController: UINavigationController
    let httpClient: UPHttpClient
    
    init(navigationController: UINavigationController, httpClient: UPHttpClient) {
        self.navigationController = navigationController
        self.httpClient = httpClient
    }
    
    func start(withID id: Int){
        let homeService = HttpHomeService(httpClient: httpClient)
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let viewModel = UPCategoryViewModel(homeService: homeService, outletRepository: outletRepository, selectedCategoryID: id)
        let viewController = UPCategoriesListingViewComposer.createViewForUPCategoriesListing(viewModel: viewModel) as! UPCategoriesViewController
        viewController.onBackButtonTapped = onBackButtonTapped
        viewController.onOfferSelected = onOfferSelected
        viewController.showOutlet = onOutletSelected
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
    static func createViewForUPCategoriesListing(viewModel: UPCategoryViewModel) -> UIViewController{
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletListing", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPCategoriesViewController")
        as! UPCategoriesViewController
        
        viewController.viewModel = viewModel
        return viewController
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
    
    private func onBackButtonTapped(){
        navigationController.popViewController(animated: true)
    }
    
}
