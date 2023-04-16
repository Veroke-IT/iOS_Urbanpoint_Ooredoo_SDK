//
//  CategoryApiResponse.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/13/23.
//

import Foundation

// MARK: - Welcome
struct CategoryApiResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: CategoryApiData
    
    
    // MARK: - UPCategory
}

struct CategoryApiData: Codable {
    let collection: [UPCategory]
}


struct UPCategory: Codable {
    let id: Int?
    let name, nameAr, image, status: String?
    let forDelivery: String?
 //   let orderby: Int?
    let categoryID: Int?
    let createdAt, updatedAt: String?
    let forDeliveryOutlet: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case image, status
        case forDelivery = "for_delivery"
      //  case orderby
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case forDeliveryOutlet = "for_delivery_outlet"
    }
}
