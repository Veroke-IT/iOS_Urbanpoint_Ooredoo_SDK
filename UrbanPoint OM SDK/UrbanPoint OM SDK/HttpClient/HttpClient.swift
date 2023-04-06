//
//  HttpClient.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation

protocol UPHttpTask{
    func cancel()
}

protocol UPHttpClient{
  
    typealias Response = (Data,URLResponse)
    typealias HttpResult = Result<Response,Error>
    
    @discardableResult
    func execute(urlRequest: URLRequest, completion:@escaping (HttpResult) -> Void) -> UPHttpTask
}

final class UPURLSessionHttpClient: UPHttpClient{
    
    struct URLSessionHttpTask: UPHttpTask{
        
        let dataTask: URLSessionDataTask
        
        func cancel() {
            dataTask.cancel()
        }
    }
    
    let session: URLSession
    
    init(session: URLSession){
        self.session = session
    }
    
    func execute(urlRequest: URLRequest, completion: @escaping (HttpResult) -> Void) -> UPHttpTask {
        let dataTask = session.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error{
                completion(.failure(error))
            }else if let data,
                     let urlResponse{
                completion(.success((data,urlResponse)))
            }else{
                completion(.failure(URLError(.badServerResponse)))
            }
        }
        
        dataTask.resume()
        return URLSessionHttpTask(dataTask: dataTask)
    }
}
