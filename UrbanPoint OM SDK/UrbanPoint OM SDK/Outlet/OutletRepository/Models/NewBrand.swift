//
//  NewBrand.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import Foundation


// MARK: - Welcome
struct UPNewBrandApiResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: [UPOutlet]
}



struct UPNewBrandApiRequest: Encodable{}
