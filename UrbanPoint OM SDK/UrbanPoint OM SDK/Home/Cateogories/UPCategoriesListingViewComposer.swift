//
//  UPCategoriesListingViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/15/23.
//

import UIKit


final class UPCategoriesListingViewComposer{
    
    static func createViewForUPCategoriesListing(viewModel: UPCategoryViewModel) -> UIViewController{
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletListing", bundle: storyBoardBundle).instantiateViewController(identifier: "UPCategoriesViewController") { coder in
            UPCategoriesViewController(coder: coder, viewModel: viewModel)
        }
        
        return viewController
    }

    
}
