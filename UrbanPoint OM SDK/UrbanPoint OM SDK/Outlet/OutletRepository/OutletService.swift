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
        case nearby = "location"
        case name = "name"
    }
    enum SortOrder: String{
        case asc = "ASC"
        case desc = "DESC"
    }
    
    case outletDetail(String)
    case nearbyOutlets
    case newBrands
    case searchOutlets(String)
    case childOutlets(String?)
    case sortBy(Sort)
    case none
    case paggingIndex(String)
    case longitude(String?)
    case latitude(String?)
    case perPage(String)
    case categoryID(String)
    case collectionID(String)
    case popularCategoryID(String)
    case sortOrder(SortOrder)
    
    var values: (String,String)?{
        switch self {
        case .sortOrder(let sortOrder):
            return ("sort_order",sortOrder.rawValue)
        case .outletDetail(let id):
            return ("outlet_id",id)
        case .searchOutlets(let searchText):
            return ("search",searchText)
        case .childOutlets(let parentID):
            return (parentID == nil) ? nil : ("parents_id",parentID ?? "")
        case .sortBy(let sortCondition):
            return ("sort_by",sortCondition.rawValue)
        case .paggingIndex(let index):
            return ("page",index)
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
        case .perPage(let perPage):
                return ("per_page",perPage)
        case .categoryID(let id):
            return ("category_id",id)
        case .collectionID(let id):
            return ("collection_id",id)
        case .popularCategoryID(let id):
            return ("popular_category_id",id)
        default:
            return nil
        }
    }
}

protocol OutletRepository{
    func fetchOutlet(param: [OutletRepositoryParam] ,completion: @escaping (Result<[UPOutlet],Error>) -> Void)
    func fetchParentOutlet(param: [OutletRepositoryParam] ,completion: @escaping (Result<[UPParentOutlet],Error>) -> Void)
    func fetchNewBrandsNearby(param: [OutletRepositoryParam], completion: @escaping (Result<[UPOutlet],Error>) -> Void)
    func fetchNewBrandsAlphabatical(param: [OutletRepositoryParam], completion: @escaping (Result<[UPParentOutlet],Error>) -> Void)
    func fetchNearbyOutlets(param: [OutletRepositoryParam], completion: @escaping (Result<[UPOutlet],Error>) -> Void)

}


final class URLSessionOutletRepository: OutletRepository{

    
  
    let httpClient: UPHttpClient
   
    init(httpClient: UPHttpClient) {
        self.httpClient = httpClient
    }
   
    
    func fetchParentOutlet(param: [OutletRepositoryParam], completion: @escaping (Result<[UPParentOutlet], Error>) -> Void) {
        let urlString = "\(baseURL)mobile/getOutletsParents"
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
        urlRequest.setValue(UPUserAuthToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(appID, forHTTPHeaderField: "APP_ID")
        httpClient.execute(urlRequest: urlRequest) {  result in
            switch result{
            case .success(let response):
               
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPOutletParentApiResponse.self, from: response.0)
                        completion(.success(jsonDecoded.data))
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
    
    
    
    func fetchOutlet(param: [OutletRepositoryParam],completion: @escaping (Result<[UPOutlet],Error>) -> Void){
        
        let urlString = "\(baseURL)mobile/getOutlets"
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
        urlRequest.setValue(UPUserAuthToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(appID, forHTTPHeaderField: "APP_ID")
      
        httpClient.execute(urlRequest: urlRequest) {  result in
       
            switch result{
            case .success(let response):
               
                if response.1.isOK{
                    do{
                        let jsonDecoded = try JSONDecoder().decode(UPOutletApiResponse.self, from: response.0)
                        completion(.success(jsonDecoded.data))
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
    
    
    
    
}
