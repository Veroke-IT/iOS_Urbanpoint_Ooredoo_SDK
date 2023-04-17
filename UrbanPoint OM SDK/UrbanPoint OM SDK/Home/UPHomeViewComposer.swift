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
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    static func createHomeView(homeService: HomeService,httpClient: UPHttpClient) -> UIViewController{
        let viewModel = UPHomeViewModel(homeService: homeService)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "HomeView", bundle: storyBoardBundle).instantiateViewController(identifier: "UPHomeViewController") { coder in
            UPHomeViewController(coder: coder, presenter: viewModel)
        }
        
        return viewController
    }
    
    private func onOutletSelected(_ id: Int){
        let outletDetailComposer = UPOutletDetailComposer(navigationController: navigationController, httpClient: httpClient, outletID: id)
        outletDetailComposer.start()
    }
    
    private func onOfferSelected(_ id: Int){
        let offerDetailVC = UPOfferDetailComposer.createOfferDetailView(offerID: id, httpClient: httpClient)
        navigationController.pushViewController(offerDetailVC, animated: true)
    }
    
    private func onViewAllNearbyTapped(){
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let nearbyListingViewModel = NearbyListingViewModel(outletRepository: outletRepository)
        let newBrandVC = NewBrandComposer.createNewBrandViewController(viewModel: nearbyListingViewModel, titleString: "Nearby Outlets", onBackButtonTapped: pop)
        self.navigationController.pushViewController(newBrandVC, animated: true)
    }
    
    private func onViewAllNewBrandsTapped(){
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let nearbyListingViewModel = UPNewBrandViewModel(outletService: outletRepository)
        let newBrandVC = NewBrandComposer.createNewBrandViewController(viewModel: nearbyListingViewModel, titleString: "New Brands", onBackButtonTapped: pop)
        
        self.navigationController.pushViewController(newBrandVC, animated: true)
    }
    
    private func onCategorySelected(id: Int){
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let upCategoryViewModel = UPCategoryViewModel(homeService: homeService, outletRepository: outletRepository,selectedCategoryID: id)
        let viewController = UPCategoriesListingViewComposer.createViewForUPCategoriesListing(viewModel: upCategoryViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func onPoularCategorySelected(id: Int,categoryName: String){
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let nearbyListingViewModel = UPPopularCategoryViewModel(outletRepository: outletRepository, selectedPopularCategoryID: id)
        let searchRepository = UPTrendingSearchHttpRepository(httpClient: httpClient)
        let searchViewModel = UPOutletSearchViewModel(trendingSearchRespository: searchRepository, outletRespository: outletRepository)
        let newBrandVC = NewBrandComposer.createNewBrandViewController(viewModel: nearbyListingViewModel, titleString: categoryName,searchViewModel: searchViewModel ,onBackButtonTapped: pop)
        self.navigationController.pushViewController(newBrandVC, animated: true)
    }
    
    private func pop(){
        self.navigationController.popViewController(animated: true)
    }
}
