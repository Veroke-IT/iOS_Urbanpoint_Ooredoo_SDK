//
//  UPOutletDetailComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit
final class UPOutletDetailComposer{
    

    static func createOutletDetailView(outletID id: Int,httpClient: UPHttpClient) -> UIViewController{
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let viewModel = UPOutletDetailViewModel(outletID: id, outletRepository: outletRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletDetail", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "OutletDetailViewController") as! OutletDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    
}
