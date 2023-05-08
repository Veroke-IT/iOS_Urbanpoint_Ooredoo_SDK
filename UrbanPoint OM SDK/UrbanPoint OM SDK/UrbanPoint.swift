//
//  UrbanPoint.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit




final public class UrbanPoint{
    
    private let context: UIViewController
    private let walletID: String
    private let publicKey: String
    private let environment: String
    
    public init(context: UIViewController, walletID: String, env: String, publicKey: String) {
        self.context = context
        self.walletID = walletID
        self.environment = env
        self.publicKey = publicKey

    }

    private enum SDKInitliazationError: Error,LocalizedError{
        
        case notInitializedCorrectly
        
    
    }

    
    public func start() throws {
       
        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)
        let authorizationService = HttpAuthorizationService(httpClient: httpClient)
        let authorizationManager = UrbanPointAuthorization(authorizationService: authorizationService, encryptionService: CryptoJS.AES())
       
        let storedPublicKeyInternal = authorizationManager.decrypt(key: publicKeyUPEncryptedInternal)
        let storedPublicKeyProduction = authorizationManager.decrypt(key: publicKeyUPEncryptedProduction)
        let storedEnvInternal = authorizationManager.decrypt(key: environmentEncryptedInternal)
        let storedEnvProduction = authorizationManager.decrypt(key: environmentEncryptedProduction)
        
        
       
        
        if self.publicKey == storedPublicKeyInternal && self.environment == storedEnvInternal{
            appEnvironment = .test_up_intrnl
        }else if self.publicKey == storedPublicKeyProduction && self.environment == storedEnvProduction{
            appEnvironment = .live_om_prd
        }else{
            throw SDKInitliazationError.notInitializedCorrectly
        }
        loadFonts()
       
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        context.present(navigationController, animated: true)
        navigationController.showActivityIndicator()
        authorizationManager.fetchAuthToken(forWalletID: walletID) {[weak self] error in
            if let error{
                self?.context.showAlert(title: .error, message: error.localizedDescription,onOkTapped: {
                    DispatchQueue.main.async {
                        navigationController.hideActivityIndicator()
                        navigationController.dismiss(animated: true)
                    }
                })
            }else{
                DispatchQueue.main.async {
                    navigationController.hideActivityIndicator()
                    let homeViewController = UPHomeViewComposer(navigationController: navigationController, httpClient: httpClient)
                    homeViewController.start()
                }
            }
        }
    }
    
    private func loadFonts(){
        FontLoader.loadFont(name: "Roboto-Medium", fontExtension: "ttf")
        FontLoader.loadFont(name: "Roboto-Bold", fontExtension: "ttf")
        FontLoader.loadFont(name: "Roboto-Regular", fontExtension: "ttf")
        FontLoader.loadFont(name: "DIN NEXT™ ARABIC REGULAR", fontExtension: "otf")
        FontLoader.loadFont(name: "DIN NEXT™ ARABIC BOLD", fontExtension: "otf")
        FontLoader.loadFont(name: "DIN NEXT™ ARABIC MEDIUM", fontExtension: "otf")

    }
    
}


