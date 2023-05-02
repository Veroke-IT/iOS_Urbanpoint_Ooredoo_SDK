//
//  UrbanPoint.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit




final public class UrbanPoint{
    
    private let context: UIViewController
    
    public init(context: UIViewController) {
        self.context = context
    }
    
    public func start(){
        
        
        FontLoader.loadFont(name: "Roboto-Medium")
        FontLoader.loadFont(name: "Roboto-Bold")
        FontLoader.loadFont(name: "Roboto-Regular")

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
