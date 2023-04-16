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
    
    static func createNewBrandViewController(viewModel: OutletListingPresenterContract,titleString: String) -> UIViewController{
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "NewBrands", bundle: storyBoardBundle).instantiateViewController(identifier: "NewBrandViewController") { coder in
            NewBrandViewController(coder: coder, viewModel: viewModel, titleString: titleString)
        }
        
       // viewController.homePresenter = viewModel
        return viewController
    }
    
    
    
}
