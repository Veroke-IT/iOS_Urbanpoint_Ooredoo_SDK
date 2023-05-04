//
//  UrbanPoint.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit




final public class UrbanPoint{
    
    private let context: UIViewController
    private let authorizatio: String
    
    public init(context: UIViewController,authorization: String) {
        self.context = context
        self.authorizatio = authorization
    }
    
    enum UrbanPointInitializationFailedError: Error{
        case failed
    }
    
    public func start() {
        
        
        //throw UrbanPointInitializationFailedError.failed
        
        FontLoader.loadFont(name: "Roboto-Medium", fontExtension: "ttf")
        FontLoader.loadFont(name: "Roboto-Bold", fontExtension: "ttf")
        FontLoader.loadFont(name: "Roboto-Regular", fontExtension: "ttf")

        FontLoader.loadFont(name: "DIN NEXT™ ARABIC REGULAR", fontExtension: "otf")
        FontLoader.loadFont(name: "DIN NEXT™ ARABIC BOLD", fontExtension: "otf")
        FontLoader.loadFont(name: "DIN NEXT™ ARABIC MEDIUM", fontExtension: "otf")
      
        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)
    
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        
        //Branch.getInstance().initSession()
        let homeViewController = UPHomeViewComposer(navigationController: navigationController, httpClient: httpClient)
        homeViewController.start()
        context.present(navigationController, animated: true)
    }
    
}


public class FontLoader {
    static public func loadFont(name: String,fontExtension: String) {
        
        if let fontUrl = Bundle(for: FontLoader.self).url(forResource: name, withExtension: fontExtension),
           let dataProvider = CGDataProvider(url: fontUrl as CFURL),
           let newFont = CGFont(dataProvider)
        {
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(newFont, &error)
                {
                    print("Error loading Font!")
            } else {
                print("Loaded font")
            }
        } else {
            assertionFailure("Error loading font")
        }
    }
}
