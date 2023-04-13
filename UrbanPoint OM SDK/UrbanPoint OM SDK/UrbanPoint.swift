//
//  UrbanPoint.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit

final public class UrbanPoint{
    
    private let navigationController: UINavigationController
    private let context: UIViewController
    
    public init(navigationController: UINavigationController,context: UIViewController) {
        self.navigationController = navigationController
        self.context = context
    }
    
    public func start(){
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        
        FontLoader.loadFont(name: "Roboto-Medium")
        FontLoader.loadFont(name: "Roboto-Bold")
        FontLoader.loadFont(name: "Roboto-Regular")

        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)

        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        
        
        let repository = URLSessionOfferRepository(httpClient: httpClient)
        var homeViewController = UIStoryboard(name: "RedeemOffer", bundle: storyBoardBundle)
            .instantiateViewController(withIdentifier: "UPRedeemOfferViewController") as! UPRedeemOfferViewController
        homeViewController.viewModel = UPRedeemOfferViewModel(offerRepository: repository, offerData: UPRedeemOfferViewModel.RedeemOfferViewModel(outletName: "OutletName", offerDetails: "OfferDetails", offerID: 515, outletID: 200, outletImage: nil))
        navigationController.pushViewController(homeViewController, animated: true)
        context.present(navigationController, animated: true)
    }
    
}


public class FontLoader {
    static public func loadFont(name: String) {
        
        if let fontUrl = Bundle(for: FontLoader.self).url(forResource: name, withExtension: "ttf"),
           let dataProvider = CGDataProvider(url: fontUrl as CFURL),
           let newFont = CGFont(dataProvider)
        {
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(newFont, &error)
                {
                //    print("Error loading Font!")
            } else {
              //  print("Loaded font")
            }
        } else {
            //assertionFailure("Error loading font")
        }
    }
}
