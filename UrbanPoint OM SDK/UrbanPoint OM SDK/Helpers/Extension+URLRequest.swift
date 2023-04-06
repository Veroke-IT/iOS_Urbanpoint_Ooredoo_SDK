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
