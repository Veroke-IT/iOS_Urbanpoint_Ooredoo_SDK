//
//  UPWebViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit


final class UPWebViewComposer{
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(withURL url: URL){
        let viewController = UPWebViewComposer.createWebViewController(withURL: url)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    static func createWebViewController(withURL url: URL) -> UIViewController{
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "WebView", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPWebViewController") as! UPWebViewController
       
        viewController.urlToResource = url
        return viewController
    }
    
}
