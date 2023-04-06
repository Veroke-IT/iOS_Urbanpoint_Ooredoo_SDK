//
//  OutletService.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import Foundation

struct Outlet: Decodable{
    let outletID: Int
    let outletName: String
    let outletImage: String
    let isNewBrand: Bool
    let outletDistance: String
    let offers: [UPOffer]
}

protocol OutletRepository{
    func fetchOutlet(param: [String: Any] ,completion: @escaping (Result<[Outlet],Error>) -> Void)
}


final class URLSessionOutletRepository: OutletRepository{
    
    let httpClient: UPHttpClient
   
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    
    
    func fetchOutlet(param: [String: Any] = [:],completion: @escaping (Result<[Outlet],Error>) -> Void){
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getOutlets?search=\(param["search"] ?? "")"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        
        httpClient.execute(urlRequest: urlRequest) {[weak self]  result in
            switch result{
            case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPOutletApiResponse.self, from: response.0)
                        completion(.success((self?.createOutletFromDTO(outlet: jsonDecoded.data))!))
                    }
                    catch let error{
                        completion(.failure(error))
                    }
                }else{
                    completion(.failure(URLError(.badServerResponse)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createOutletFromDTO(outlet: [UPOutletApiResponse.Outlet]) -> [Outlet]{
        
        outlet.compactMap { outlet in
            Outlet(outletID: outlet.id, outletName: outlet.name, outletImage: outlet.image, isNewBrand: outlet.isnewBrand == "1", outletDistance: outlet.distance ?? "0", offers: outlet.offers)
        }
        
    }
    
}
