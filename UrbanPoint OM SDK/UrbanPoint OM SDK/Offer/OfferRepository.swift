//
//  OfferRepository.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/4/23.
//

import Foundation

struct UsedOffersResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: [UPOffer]
}

struct RedeemOfferRequest: Encodable{
    
    let pin: String
    let outletID: String
    let offerID: String
    
    enum CodingKeys: String, CodingKey{
        case pin = "pin"
        case outletID = "outlet_id"
        case offerID = "offer_id"
    }
    
    internal func encoded() throws -> Data{
        try JSONEncoder().encode(self)
    }
}
struct RedeemOfferResponse: Decodable{
    
    let phone: String
    
}

protocol OfferRepository{
    func fetchUsedOffer(index: Int, completion: @escaping (Result<[UPOffer],Error>) -> Void)
    func fetchOffer(withID id: Int, completion: @escaping (Result<OfferDetailApiResponse.Offer,Error>) -> Void)
    func redeemOffer(offerData: RedeemOfferRequest, completion: @escaping (Result<RedeemOfferResponse,Error>) -> Void)
}

final class URLSessionOfferRepository: OfferRepository{
   
    let httpClient: UPHttpClient
    
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchUsedOffer(index: Int, completion: @escaping (Result<[UPOffer], Error>) -> Void) {
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getAllOfferUseAgain?page=\(index)"
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
                        
                        let jsonDecoded = try JSONDecoder().decode(UsedOffersResponse.self, from: response.0)
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
    
    
    func redeemOffer(offerData: RedeemOfferRequest, completion: @escaping (Result<RedeemOfferResponse, Error>) -> Void) {
        
        let urlString = "http://ooredoo-sdk-internal.adminurban.com/api/mobile/redeemOffer"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
                  
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        do{
            urlRequest.httpBody = try offerData.encoded()
        }
        catch let error{
            completion(.failure(error))
            return
        }
        
        httpClient.execute(urlRequest: urlRequest) { result in
            switch result{
            case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(RedeemOfferResponse.self, from: response.0)
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
