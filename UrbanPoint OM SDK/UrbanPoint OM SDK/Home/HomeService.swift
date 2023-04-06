//
//  HomeService.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation



protocol HomeService{
    func fetchEssentialHomeData(completion: @escaping (Result<EssentialData,Error>) -> Void)
    func fetchRedisCacheData(completion: @escaping (Result<RedisCacheResponse,Error>) -> Void)
}

final class HttpHomeService: HomeService{
   
    
   
    let httpClient: UPHttpClient
    
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchEssentialHomeData(completion: @escaping (Result<EssentialData,Error>) -> Void) {
        guard let url = URL(string: "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getHomeApiEssentialNew")else
        {
            completion(.failure(URLError(.badURL)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
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
        guard let url = URL(string: "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getcacheHomeApiExtra")else
        {
            completion(.failure(URLError(.badURL)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
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
}
