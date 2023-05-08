//
//  OutletService+NearbyOutlets.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import Foundation

extension URLSessionOutletRepository{
 //   getOutletNew
    func fetchNearbyOutlets(param: [OutletRepositoryParam], completion: @escaping (Result<[UPOutlet],Error>) -> Void){
        
        let urlString = "\(baseURL)mobile/getOutletsNew"
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
