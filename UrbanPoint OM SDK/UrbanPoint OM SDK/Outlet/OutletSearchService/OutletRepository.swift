//
//  OutletRepository.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import Foundation


protocol UPTrendingSearchRepository{
    func fetchTrendingSearches(completion:@escaping (Result<TrendingSearchesResponse,Error>) -> Void)
    func fetchStoredSearches(completion: @escaping ([String]) -> Void)
    func addSearchToStoredSearches(searchText: String)
    
    func fetchOffersTag(searchText: String,completion:@escaping (Result<[String],Error>) -> Void) -> UPHttpTask?
    
}

final class UPTrendingSearchHttpRepository: UPTrendingSearchRepository{
    
    
    let httpClient: UPHttpClient
    static let storedSearchesIdentifier = "UPstoredSearchesIdentifier"
    
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchTrendingSearches(completion: @escaping (Result<TrendingSearchesResponse,Error>) -> Void) {
        guard let url = URL(string: "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getTrendingSearchTag")else
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
                        let jsonDecoded = try JSONDecoder().decode(TrendingSearchesResponse.self, from: response.0)
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
    
    func fetchOffersTag(searchText: String,completion:@escaping (Result<[String],Error>) -> Void) -> UPHttpTask?{
       guard let url = URL(string: "http://ooredoo-sdk-internal.adminurban.com/api/mobile/getOffersSearchTags?search=\(searchText)")else
        {
            completion(.failure(URLError(.badURL)))
            return nil
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.setValue("83cdff852bb72d9d99b5aec88888", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("1", forHTTPHeaderField: "APP_ID")
        debugPrint(url)
        return httpClient.execute(urlRequest: urlRequest) { result in
            switch result{
                case .success(let response):
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPAutoCompleteSearchesResponse.self, from: response.0)
                        completion(.success(jsonDecoded.data.tags))
                    }
                    catch DecodingError.keyNotFound(let key, let context) {
                        Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                    } catch DecodingError.valueNotFound(let type, let context) {
                        Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                    } catch DecodingError.typeMismatch(let type, let context) {
                        Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                    } catch DecodingError.dataCorrupted(let context) {
                        Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                    } catch let error as NSError {
                        NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
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
    
    func fetchStoredSearches(completion: @escaping ([String]) -> Void){
        completion(fetchAllStoredSearches())
    }

    func addSearchToStoredSearches(searchText: String) {
        var searches = fetchAllStoredSearches()
        if !searches.contains(where: { $0 == searchText }){
            searches.append(searchText)
            UserDefaults.standard.set(searches, forKey: UPTrendingSearchHttpRepository.storedSearchesIdentifier)
        }
    }
    
    private func fetchAllStoredSearches() -> [String]{
        
        if let searches = UserDefaults.standard.stringArray(forKey: UPTrendingSearchHttpRepository.storedSearchesIdentifier)
        {
            return searches
        }
        return []
    }
    
    
    
}


struct TrendingSearchesResponse: Decodable {
    let status: String
    let statusCode: Int
    let message: String
    let data: [TrendingSearchesResponse.TrendingSearch]
    
 
    struct TrendingSearch: Codable {
        let id: Int
        let text, status, createdAt, updatedAt: String

        enum CodingKeys: String, CodingKey {
            case id, text, status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }

}



// MARK: - Welcome
struct UPAutoCompleteSearchesResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: Tags
    
    struct Tags: Codable {
        let search: String
        let tags: [String]
    }
    
}


