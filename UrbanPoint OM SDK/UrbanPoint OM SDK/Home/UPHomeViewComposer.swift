//
//  UPHomeViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit


final class UPHomeViewComposer{
    
    let navigationController: UINavigationController
    let httpClient: UPHttpClient
    
    init(navigationController: UINavigationController,httpClient: UPHttpClient) {
        self.navigationController = navigationController
        self.httpClient = httpClient
    }
    
    internal func start(){
        let homeViewController = UPHomeViewComposer.createHomeView(httpClient: httpClient)
        as! UPHomeViewController
        homeViewController.showOutletDetail = onOutletSelected
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    static func createHomeView(httpClient: UPHttpClient) -> UIViewController{
        let homeService = HttpHomeService(httpClient: httpClient)
        let viewModel = UPHomeViewModel(homeService: homeService)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "HomeView", bundle: storyBoardBundle).instantiateViewController(identifier: "UPHomeViewController") { coder in
            UPHomeViewController(coder: coder, presenter: viewModel)
        }
        
        viewController.homePresenter = viewModel
        return viewController
    }
    
    private func onOutletSelected(_ id: Int){
        let outletDetailVC = UPOutletDetailComposer.createOutletDetailView(outletID: id, httpClient: httpClient)
        navigationController.pushViewController(outletDetailVC, animated: true)
    }
    
    private func onOfferSelected(_ id: Int){
        let offerDetailVC = UPOfferDetailComposer.createOfferDetailView(offerID: id, httpClient: httpClient)
        navigationController.pushViewController(offerDetailVC, animated: true)
    }
    
    
}
