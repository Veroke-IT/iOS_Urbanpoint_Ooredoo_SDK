//
//  AuthorizationManager.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 5/5/23.
//

import Foundation

final class UrbanPointAuthorization{
    
    private let authorizationService: AuthorizationService
    private let encryptionService: CryptoJS.AES
  
    init(authorizationService: AuthorizationService, encryptionService: CryptoJS.AES) {
        self.authorizationService = authorizationService
        self.encryptionService = encryptionService
    }
    
    private func encrypt(key: String) -> String{
        return encryptionService.encrypt(key, password: passwordEncryption)
    }
    
    internal func decrypt(key: String) -> String{
        encryptionService.decrypt(key, password: passwordEncryption)
    }
    
    internal func fetchAuthToken(forWalletID id: String, completion: @escaping (Error?) -> Void){
        let encryptedWalledID = encrypt(key: id)
        let authRequest = AuthApiRequest(walletID: encryptedWalledID)
        authorizationService.fetchAuthToken(request: authRequest) { error in
            if let error {
                completion(error)
            }else{
                completion(nil)
            }
        }
    }
    
}

extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}
