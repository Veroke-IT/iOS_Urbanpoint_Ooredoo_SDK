//
//  SettingsViewComposer.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import UIKit



final class UPSettingsViewComposer{
    
    let navigationController: UINavigationController
    let httpClient: UPHttpClient
    
    init(navigationController: UINavigationController, httpClient: UPHttpClient) {
        self.navigationController = navigationController
        self.httpClient = httpClient
    }
    
    func start(){
        let viewController = UPSettingsViewComposer.createSettingsView()
        as! UPSettingsViewController
        viewController.onBack = onBackButtonTapped
        viewController.showUsedOffers = onUsedOffersTapped
        viewController.onSwitchMoved = onSwitchChanged
        viewController.showTermsAndConditions = onTermsAndConditionsTapped
        viewController.onGoBackToOoreddo = onGoBackToOoredooTapped
        navigationController.pushViewController(viewController, animated: true)
    }
    
    static func createSettingsView() -> UIViewController{
        var viewControllerName = "UPSettingsViewController"
        if appLanguage == .arabic{
            viewControllerName += "_ar"
        }
        
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "Settings", bundle: storyBoardBundle).instantiateViewController(withIdentifier: viewControllerName) as! UPSettingsViewController
        return viewController
    }
    
    private func onGoBackToOoredooTapped(){
        navigationController.dismiss(animated: true)
    }
    
    private func onTermsAndConditionsTapped(){
        if let url = URL(string: termsAndServiceURL){
            let webViewFlow = UPWebViewComposer(navigationController: navigationController)
            webViewFlow.start(withURL: url)
        }
    }
    
    private func onSwitchChanged(isOn: Bool){
        
        if isOn{
            appLanguage = .english
        }else{
            appLanguage = .arabic
        }
        navigationController.popToRootViewController(animated: true)
        navigationController.popViewController(animated: false)
        let homeViewComposer = UPHomeViewComposer(navigationController: navigationController, httpClient: httpClient)
        homeViewComposer.start()
    }
    
    private func onUsedOffersTapped(){
        let usedOfferFlow = UPUsedOfferViewComposer(httpClient: httpClient, navigationController: navigationController)
        usedOfferFlow.start()
        
    }
    
    private func onBackButtonTapped(){
        navigationController.popViewController(animated: true)
    }
    
}
