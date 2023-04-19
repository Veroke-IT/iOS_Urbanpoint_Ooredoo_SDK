//
//  UrbanPoint.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit
import BranchSDK




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
//        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
//        let offerRepository = URLSessionOfferRepository(httpClient: httpClient)
//        let homeService = HttpHomeService(httpClient: httpClient)
        
        Branch.getInstance().initSession(launchOptions: nil) { params, error in
            debugPrint(error)
        }
        let homeViewController = UPHomeViewComposer(navigationController: navigationController, httpClient: httpClient)
        homeViewController.start()
        Branch.getInstance().initSession()
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
