//
//  UPOutletDetailComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit
final class UPOutletDetailComposer{
    
    let navigationController: UINavigationController
    let httpClient: UPHttpClient
    private let outletID: Int
    
    init(navigationController: UINavigationController, httpClient: UPHttpClient, outletID: Int) {
        self.navigationController = navigationController
        self.httpClient = httpClient
        self.outletID = outletID
        
    }
    
    internal func start(){
        let outletDetailVC = UPOutletDetailComposer.createOutletDetailView(outletID: outletID, httpClient: httpClient) as! OutletDetailViewController
        outletDetailVC.onOfferSelected = onOfferSelected
        navigationController.pushViewController(outletDetailVC, animated: true)
        
    }
    
    private func onOfferSelected(withID id: Int){
        let offerDetailComposer = UPOfferDetailComposer(navigationController: navigationController, httpClient: httpClient, offerID: id)
        offerDetailComposer.start()
    }

    static func createOutletDetailView(outletID id: Int,httpClient: UPHttpClient) -> UIViewController{
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let viewModel = UPOutletDetailViewModel(outletID: id, outletRepository: outletRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletDetail", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "OutletDetailViewController") as! OutletDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    
}
