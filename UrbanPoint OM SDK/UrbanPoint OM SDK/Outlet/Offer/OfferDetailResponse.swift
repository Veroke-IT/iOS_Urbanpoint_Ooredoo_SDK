//
//  OfferDetailResponse.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/4/23.
//

import Foundation

struct OfferDetailApiResponse: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: [Offer]
    
    struct Offer: Codable {
        let title, image, searchTags: String?
        let outletID, price, specialPrice, approxSaving: Int?
        let description: String?
        let id: Int?
        let sku, interestTags, percentageSaving, startDatetime: String?
        let endDatetime, validFor, special, usageAllowance: String?
        let specialType, renew: String?
        let redemptions, redeemed, perUser, ordersCount: Int?
        let active, rulesOfPurchase, discountType: String?
        let outlet: Outlet?
        let isRedeeme, isFavorite: Bool?

        enum CodingKeys: String, CodingKey {
            case title, image
            case searchTags = "search_tags"
            case outletID = "outlet_id"
            case price
            case specialPrice = "special_price"
            case approxSaving = "approx_saving"
            case description, id
            case sku = "SKU"
            case interestTags = "interest_tags"
            case percentageSaving = "percentage_saving"
            case startDatetime = "start_datetime"
            case endDatetime = "end_datetime"
            case validFor = "valid_for"
            case special
            case usageAllowance = "usage_allowance"
            case specialType = "special_type"
            case renew, redemptions, redeemed
            case perUser = "per_user"
            case ordersCount = "orders_count"
            case active
            case rulesOfPurchase = "rules_of_purchase"
            case discountType = "discount_type"
            case outlet, isRedeeme, isFavorite
        }
        
        
        struct Outlet: Codable {
            let name, logo: String?
            let latitude, longitude: Double?
            let address, locationImage: String?
            let linkedOutletCategory: [LinkedOutletCategory]?

            enum CodingKeys: String, CodingKey {
                case name, logo, latitude, longitude, address
                case locationImage = "location_image"
                case linkedOutletCategory = "linked_outlet_category"
            }
        }
    }
}

