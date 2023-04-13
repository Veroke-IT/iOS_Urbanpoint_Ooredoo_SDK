//
//  Extension+URLRequest.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation

extension URLResponse{
    
    var isOK:Bool {
        let statusCode = (self as? HTTPURLResponse)?.statusCode ?? 0
        return (statusCode >= 200 && statusCode < 300)
    }
}

extension URL {
    func appending(_ queryItem: String, value: String?) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
