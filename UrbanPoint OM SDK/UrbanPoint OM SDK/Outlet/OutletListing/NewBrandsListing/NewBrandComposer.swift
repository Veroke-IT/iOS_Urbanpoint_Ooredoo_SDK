//
//  NewBrandComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import UIKit


final class NewBrandComposer{

    
    let httpClient: UPHttpClient
    let navigationController: UINavigationController
    
    init(httpClient: UPHttpClient, navigationController: UINavigationController) {
        self.httpClient = httpClient
        self.navigationController = navigationController
    }
    
    func start(withListingType type: UPOutletListingType){
        var searchViewModel: UPOutletSearchViewModel? = nil
        var viewModel: OutletListingPresenterContract? = nil
        var titleString = ""
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        switch type{
        case .nearby:
            viewModel = NearbyListingViewModel(outletRepository: outletRepository)
            titleString = "Nearby Outlets"
        case .child(let parentID,let parentName):
            viewModel = ChildOutletListingViewModel(outletRepository: outletRepository, parentID: parentID)
            titleString = parentName
        case .newBrand:
            viewModel = UPNewBrandViewModel(outletService: outletRepository)
            titleString = "New Brand"
        case .popularCategory(let id,let name):
            let trendingSearchRepo = UPTrendingSearchHttpRepository(httpClient: httpClient)
            searchViewModel = UPOutletSearchViewModel(trendingSearchRespository: trendingSearchRepo, outletRespository: outletRepository)
            viewModel = UPPopularCategoryViewModel(outletRepository: outletRepository, selectedPopularCategoryID: id)
            titleString = name
        }
        let viewController = NewBrandComposer.createNewBrandViewController(viewModel: viewModel!, titleString: titleString, onBackButtonTapped: onBackButtonTapped) as! NewBrandViewController
        viewController.onOfferSelected = onOfferSelected
        viewController.showOutlet = onOutletSelected
        viewController.searchingViewModel = searchViewModel
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    private func onOfferSelected(withID id: Int){
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
    
    static func createNewBrandViewController(viewModel: OutletListingPresenterContract,
                                             titleString: String,
                                             searchViewModel: UPOutletSearchViewModel? = nil,
                                             onBackButtonTapped: @escaping () -> Void) -> UIViewController{
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "NewBrands", bundle: storyBoardBundle).instantiateViewController(identifier: "NewBrandViewController") { coder in
            
   
            NewBrandViewController(coder: coder, viewModel: viewModel, titleString: titleString, searchViewModel: searchViewModel, onBackButtonTapped: onBackButtonTapped)
        }
        
        return viewController
    }
    
    
    
}
