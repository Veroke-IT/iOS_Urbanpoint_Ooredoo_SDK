//
//  HomeService.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation



protocol HomeService{
    func fetchEssentialHomeData(location: (String,String),completion: @escaping (Result<EssentialData,Error>) -> Void)
    func fetchRedisCacheData(completion: @escaping (Result<RedisCacheResponse,Error>) -> Void)
    func fetchHomeApiDetail(cateogoryID:Int, completion: @escaping (Result<CategoryApiResponse,Error>) -> Void)
}

final class HttpHomeService: HomeService{

   
    
   
    let httpClient: UPHttpClient
    
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchEssentialHomeData(location: (String,String),completion: @escaping (Result<EssentialData,Error>) -> Void) {
        guard var url = URL(string: "\(baseURL)mobile/getHomeApiEssentialNew")else
        {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        url = url.appending("longitude",value: location.0)!
        url = url.appending("latitude",value:location.1)!
  
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue(UPUserAuthToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(appID, forHTTPHeaderField: "APP_ID")
        httpClient.execute(urlRequest: urlRequest) { result in
            switch result{
                case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(EssentialData.self, from: response.0)
                        completion(.success(jsonDecoded))
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
    
    func fetchRedisCacheData(completion: @escaping (Result<RedisCacheResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)mobile/getcacheHomeApiExtra")else
        {
            completion(.failure(URLError(.badURL)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue(UPUserAuthToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(appID, forHTTPHeaderField: "APP_ID")
        httpClient.execute(urlRequest: urlRequest) { result in
            switch result{
                case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(RedisCacheResponse.self, from: response.0)
                        completion(.success(jsonDecoded))
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
    
    func fetchHomeApiDetail(cateogoryID categoryID: Int,completion: @escaping (Result<CategoryApiResponse, Error>) -> Void) {
       
        guard var url = URL(string: "\(baseURL)mobile/homeApiDetails")else
        {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        url = url.appending("category_id", value: String(categoryID))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue(UPUserAuthToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(appID, forHTTPHeaderField: "APP_ID")
        
        httpClient.execute(urlRequest: urlRequest) { result in
            switch result{
                case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(CategoryApiResponse.self, from: response.0)
                        completion(.success(jsonDecoded))
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
