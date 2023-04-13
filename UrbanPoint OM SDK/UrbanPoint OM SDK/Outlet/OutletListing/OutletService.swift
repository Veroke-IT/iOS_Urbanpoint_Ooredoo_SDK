//
//  OutletService.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import Foundation
import CoreLocation


enum OutletRepositoryParam{
    
    enum Sort: String{
        case alphabatical = "alphabetically"
        case nearby = "nearby"
    }
    
    case outletDetail(String)
    case nearbyOutlets
    case newBrands
    case searchOutlets(String)
    case childOutlets(String?)
    case sortBy(OutletRepositoryParam.Sort)
    case none
    case paggingIndex(String)
    case longitude(String?)
    case latitude(String?)
    
    var values: (String,String)?{
        switch self {
        case .outletDetail(let id):
            return ("outlet_id",id)
        case .searchOutlets(let searchText):
            return ("search",searchText)
        case .childOutlets(let parentID):
            return (parentID == nil) ? nil : ("parents_id",parentID ?? "")
        case .sortBy(let sortCondition):
            return ("sortBy",sortCondition.rawValue)
        case .paggingIndex(let index):
            return ("index",index)
        case .longitude(let coordinates):
            if let coordinates{
                return ("longitude",coordinates)
            }
            return nil
        case .latitude(let coordinates):
            if let coordinates{
                return ("latitude",coordinates)
            }
            return nil
            
        default:
            return nil

        }
    }
}

protocol OutletRepository{
    
    func fetchOutlet(param: [OutletRepositoryParam] ,completion: @escaping (Result<[UPOutletApiResponse.Outlet],Error>) -> Void)
}


final class URLSessionOutletRepository: OutletRepository{
    
    let httpClient: UPHttpClient
   
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchOutlet(param: [OutletRepositoryParam],completion: @escaping (Result<[UPOutletApiResponse.Outlet],Error>) -> Void){
        
        
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getOutlets"
        guard var url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        if !param.isEmpty{
            param.forEach { param in
                if let values = param.values{
                   url = url.appending(values.0, value: values.1)!
                }
            }
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        
        httpClient.execute(urlRequest: urlRequest) {  result in
       
            switch result{
            case .success(let response):
               
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPOutletApiResponse.self, from: response.0)
                        completion(.success(jsonDecoded.data))
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
    
    
}
