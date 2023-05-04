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
        outletDetailVC.recentlyVisitEventDelegate = UserDefaultsRecentlyViewedOutletWrapper.sharedInstance
        outletDetailVC.onBackButtonTapped = onBackButtonTapped
        outletDetailVC.onMenuSelected = onMenuSelected
        navigationController.pushViewController(outletDetailVC, animated: true)
        
    }
    
    private func onOfferSelected(withID id: Int){
        let offerDetailComposer = UPOfferDetailComposer(navigationController: navigationController, httpClient: httpClient, offerID: id)
        offerDetailComposer.start()
    }
    
    private func onBackButtonTapped(){
        navigationController.popViewController(animated: true)
    }
    
    private func onMenuSelected(menu: [UPOutlet.OutletMenu]){
        
        if !menu.isEmpty{
            guard let first = menu.first,
                  let file = first.file
            else { return }
            if first.type == "image"{
                
                let vc = UIStoryboard(name: "OutletDetail", bundle: Appbundle   ).instantiateViewController(withIdentifier: "OutletMenuCardImageViewController") as! OutletMenuCardImageViewController
                vc.outletMenu = menu
                navigationController.pushViewController(vc, animated: true)
            }
            else{
                var urlString: String = ""
                if first.type == "url"{
                    urlString = file
                }else{
                    urlString = imageBaseURL + file
                }
                
                if let url = URL(string: urlString){
                    let webViewFlow = UPWebViewComposer(navigationController: navigationController)
                    webViewFlow.start(withURL: url)
                }
            }
        }
        
    }

    static func createOutletDetailView(outletID id: Int,httpClient: UPHttpClient) -> UIViewController{
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let viewModel = UPOutletDetailViewModel(outletID: id, outletRepository: outletRepository)
        var viewControllerName = "OutletDetailViewController"
        if appLanguage == .arabic{
            viewControllerName += "_ar"
        }
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletDetail", bundle: storyBoardBundle).instantiateViewController(withIdentifier: viewControllerName) as! OutletDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    
}
