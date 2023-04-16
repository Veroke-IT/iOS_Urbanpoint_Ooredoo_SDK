//
//  UPOutletParent.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/13/23.
//

import Foundation

struct UPOutletParentApiResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: [UPParentOutlet]

}

struct UPParentOutlet: Codable {
    let name, logo, special: String?
    let id: Int?
    let createdAt, updatedAt: String?
    let totalOutlets: Int?
   // let distance: String?
    let outlets: [UPOutlet]?

    enum CodingKeys: String, CodingKey {
        case name, logo, special, id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case totalOutlets = "total_outlets"
        case  outlets
    }
}


