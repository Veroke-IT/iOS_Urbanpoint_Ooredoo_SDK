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
    let homeService: HomeService
    
    init(navigationController: UINavigationController,httpClient: UPHttpClient) {
        self.navigationController = navigationController
        self.httpClient = httpClient
        homeService = HttpHomeService(httpClient: httpClient)
      
    }
    
    internal func start(){
      
        let homeViewController = UPHomeViewComposer.createHomeView(homeService: homeService, httpClient: httpClient)
        as! UPHomeViewController
        
        homeViewController.showOutletDetail = onOutletSelected
        homeViewController.onNewBrandsTapped = onViewAllNewBrandsTapped
        homeViewController.onViewAllNearbyOutletsTapped = onViewAllNearbyTapped
        homeViewController.onCategorySelected = onCategorySelected
        homeViewController.onPopoularCategorySelected = onPoularCategorySelected
        homeViewController.onTopBarTapped = onSearchBarTapped
        homeViewController.onParentBrandSelected = onParentSelected
        homeViewController.showUseAgainOffer = onOfferSelected
        homeViewController.onSettingButtonTapped = onSettingButtonTapped
        homeViewController.onViewAllOffersTapped = onViewAllOffersTapped
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    static func createHomeView(homeService: HomeService,httpClient: UPHttpClient) -> UIViewController{
        let viewModel = UPHomeViewModel(homeService: homeService)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "HomeView", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPHomeViewController") as! UPHomeViewController
        
        viewController.homePresenter = viewModel
        return viewController
    }
    
    
    
    private func onOutletSelected(_ id: Int){
        let outletDetailComposer = UPOutletDetailComposer(navigationController: navigationController, httpClient: httpClient, outletID: id)
        outletDetailComposer.start()
    }
    
    private func onOfferSelected(_ id: Int){
        let offerDetailVC = UPOfferDetailComposer(navigationController: navigationController, httpClient: httpClient, offerID: id)
        offerDetailVC.start()
    }
    
    private func onParentSelected(withID id: Int,name: String){
        let listingViewController = NewBrandComposer(httpClient: httpClient, navigationController: navigationController)
        listingViewController.start(withListingType: .child(id, name))
    }
    
    private func onViewAllNearbyTapped(){
        let listingViewController = NewBrandComposer(httpClient: httpClient, navigationController: navigationController)
         listingViewController.start(withListingType: .nearby)
    }
    
    private func onViewAllNewBrandsTapped(){
        let listingViewController = NewBrandComposer(httpClient: httpClient, navigationController: navigationController)
         listingViewController.start(withListingType: .newBrand)
    }
    
    private func onCategorySelected(id: Int){
        let categoryFlow = UPCategoriesListingViewComposer(navigationController: navigationController, httpClient: httpClient)
        categoryFlow.start(withID: id)
    }
    
    private func onPoularCategorySelected(id: Int,categoryName: String){
       let listingViewController = NewBrandComposer(httpClient: httpClient, navigationController: navigationController)
        listingViewController.start(withListingType: .popularCategory(id, categoryName))
    }
    
    private func onSettingButtonTapped(){
        let settingFlow = UPSettingsViewComposer(navigationController: navigationController, httpClient: httpClient)
        settingFlow.start()
    }
    
    private func onSearchBarTapped(){
        let searchFlow = UPSearchViewComposer(httpClient: httpClient, naviagtionController: navigationController)
        searchFlow.start()
    }
    
    private func onViewAllOffersTapped(){
        let usedOfferFlow = UPUsedOfferViewComposer(httpClient: httpClient, navigationController: navigationController)
        usedOfferFlow.start()
    }
    


}
