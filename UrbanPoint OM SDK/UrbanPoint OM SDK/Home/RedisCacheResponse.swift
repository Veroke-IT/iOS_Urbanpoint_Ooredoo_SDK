//
//  RedisCacheResponse.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import Foundation

struct RedisCacheResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: Data
    
    struct Data: Codable {
        let categories: [Category]
        let newBrands: [NewBrand]
        let popularCategories: [PopularCategory]
        let featured: [Featured]
    }
}



// MARK: - Category
struct Category: Codable {
    let id, name, nameAr, description: String
    let imageV2, image, logo, status: String
    let orderby: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case description
        case imageV2 = "image_v2"
        case image, logo, status, orderby
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Featured
struct Featured: Codable {
    let name: String
    let id, parentsID: Int
    let outletLogo, outletImage: String
    let outletsParents: OutletsParents
    let linkedOutletCategory: [LinkedOutletCategory]

    enum CodingKeys: String, CodingKey {
        case name, id
        case parentsID = "parents_id"
        case outletLogo = "outlet_logo"
        case outletImage = "outlet_image"
        case outletsParents = "outlets_parents"
        case linkedOutletCategory = "linked_outlet_category"
    }
}


// MARK: - OutletsParents
struct OutletsParents: Codable {
    let id: Int?
    let name, checkMultipleChild: String?
}

// MARK: - NewBrand
struct NewBrand: Codable {
    let parentsID, id, outletID, outletImage: String
    let outletLogo, outletType, deliveryStatus, createdAt: String
    let parentOutletID, parentOutletName, isnewBrand, isnewbrandExpiry: String
    let otherOutletAddress, otherOutletCount: String
    let isMultipleChild: Bool
    let categoryID, categoryName, categoryNameAr, categoryImage: String
    let categoryLogo: String

    enum CodingKeys: String, CodingKey {
        case parentsID = "parents_id"
        case id
        case outletID = "outlet_id"
        case outletImage = "outlet_image"
        case outletLogo = "outlet_logo"
        case outletType = "outlet_type"
        case deliveryStatus = "delivery_status"
        case createdAt = "created_at"
        case parentOutletID = "parent_outlet_id"
        case parentOutletName = "parent_outlet_name"
        case isnewBrand = "isnew_brand"
        case isnewbrandExpiry = "isnewbrand_expiry"
        case otherOutletAddress = "other_outlet_address"
        case otherOutletCount = "other_outlet_count"
        case isMultipleChild
        case categoryID = "category_id"
        case categoryName = "category_name"
        case categoryNameAr = "category_name_ar"
        case categoryImage = "category_image"
        case categoryLogo = "category_logo"
    }
}

// MARK: - PopularCategory
struct PopularCategory: Codable {
    let id: Int
    let name, nameAr: String
    let description: String?
    let image, status: String
    let orderby: Int?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case description, image, status, orderby
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
