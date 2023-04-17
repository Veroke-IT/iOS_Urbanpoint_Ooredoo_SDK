//
//  OutletService+Extension+NewBrands.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import Foundation

extension URLSessionOutletRepository{
    func fetchNewBrandsNearby(param: [OutletRepositoryParam], completion: @escaping (Result<[UPOutlet],Error>) -> Void)
    {
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getBrandsOutlets"
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
        
        debugPrint("Api URL", url.absoluteURL)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        httpClient.execute(urlRequest: urlRequest) {  result in
            switch result{
            case .success(let response):
                
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPNewBrandApiResponse.self, from: response.0)
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
    
    func fetchNewBrandsAlphabatical(param: [OutletRepositoryParam], completion: @escaping (Result<[UPParentOutlet],Error>) -> Void)
    {
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getAllNewBrands"
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
        
        debugPrint("Api URL", url.absoluteURL)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        
        httpClient.execute(urlRequest: urlRequest) {  result in
       
            switch result{
            case .success(let response):
               
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPOutletParentApiResponse.self, from: response.0)
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
