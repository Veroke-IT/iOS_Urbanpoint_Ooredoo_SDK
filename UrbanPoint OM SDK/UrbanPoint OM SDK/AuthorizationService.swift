//
//  AuthorizationService.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 5/5/23.
//

import Foundation


struct AuthApiRequest: Encodable{
    let walletID: String
    
    enum CodingKeys: String,CodingKey{
        case walletID = "ooredoo_wallet_encrypted"
    }
    
    func encoded() throws -> Data{
        try JSONEncoder().encode(self)
    }
}
struct AuthApiResponse: Decodable{
       let status: String?
       let statusCode: Int?
       let message: String?
       let data: DataClass
       
        struct DataClass: Codable {
            let authKey: String

            enum CodingKeys: String, CodingKey {
                case authKey = "auth_key"
            }
        }
}

protocol AuthorizationService{
    func fetchAuthToken(request: AuthApiRequest,completion: @escaping (Error?) -> Void)
}

final class HttpAuthorizationService: AuthorizationService{
   
    let httpClient: UPHttpClient
    
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchAuthToken(request: AuthApiRequest, completion: @escaping (Error?) -> Void) {
        
        let urlString = baseURL + "auth/generateWalletAuthV1"
        guard let url = URL(string: urlString) else {
            completion((URLError(.badURL)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        urlRequest.setValue(guestAuthToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(appID, forHTTPHeaderField: "APP_ID")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
      
        do{
            urlRequest.httpBody = try request.encoded()
        }
        catch let error{
            completion(error)
            return
        }
        
        httpClient.execute(urlRequest: urlRequest) { result in
            switch result{
            case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(AuthApiResponse.self, from: response.0)
                        let authToken = jsonDecoded.data.authKey
                        UPUserAuthToken = authToken
                        completion(nil)
                    }
                    catch let error{
                        completion(error)
                    }
                }else{
                    completion(URLError(.badServerResponse))
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
}
