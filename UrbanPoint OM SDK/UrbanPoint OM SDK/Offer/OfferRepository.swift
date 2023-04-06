//
//  OfferRepository.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/4/23.
//

import Foundation

protocol OfferRepository{
    func fetchOffer(withID id: Int, completion: @escaping (Result<OfferDetailApiResponse.Offer,Error>) -> Void)
}

final class URLSessionOfferRepository: OfferRepository{
    
    let httpClient: UPHttpClient
    
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchOffer(withID id: Int, completion: @escaping (Result<OfferDetailApiResponse.Offer, Error>) -> Void) {
        
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getOffers?offer_id=\(id)"
        guard let url = URL(string: urlString) else {
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
                        
                        let jsonDecoded = try JSONDecoder().decode(OfferDetailApiResponse.self, from: response.0)
                        
                        guard let offer = jsonDecoded.data.first else {
                            completion(.failure(URLError(.badServerResponse)))
                            return
                        }
                        completion(.success(offer))
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
