//
//  UPOutlet.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import Foundation

import Foundation

// MARK: - Welcome
struct UPOutletApiResponse: Codable {
    
    let status: String
    let statusCode: Int
    let message: String
    let data: [UPOutlet]
    // MARK: - Datum
    
    

    
}



struct UPOutlet: Codable {
    let name: String?
    let emails: String?
    let phone, pin, searchTags: String?
    let phones: String?
    let logo, image, neighborhood, timings: String?
    let description, type, special, active: String?
    let merchantID: Int?
    let latitude, longitude: Double?
    let categoryIDS: String?
    let id, parentsID: Int?
    let address, outletTiming, accessTokenForBeeDelivery: String?
  //  let pendingEmailsBody: String?
    let deliveryStatus: String?
//    let playlistID, deliveryRadius: Int
    let isnewBrand: String?
   // let isnewbrandExpiry, isnewbrandCreatedAt: String?
    let sku: String?
    let popularCategoryID: Int?
    let menuCard: String?
    let enableDeliveryFor: String?
    let deliveryOperateStatus: String?
    let deliveryOptions: String?
    //let menuType: String?
    let locationImage: String?
    let busyClosedUntil: String?
    let createdAt, updatedAt: String?
   // let distance: String?
    let offers: [UPOffer]?
    let outletImages: [OutletImage]?

    enum CodingKeys: String, CodingKey {
        case name, emails, phone, phones, pin
        case searchTags = "search_tags"
        case logo, image, neighborhood, timings, description, type, special, active
        case merchantID = "merchant_id"
        case latitude, longitude
        case categoryIDS = "category_ids"
        case id
        case parentsID = "parents_id"
        case address, outletTiming
        case accessTokenForBeeDelivery = "access_token_for_bee_delivery"
      //  case pendingEmailsBody = "pending_emails_body"
        case deliveryStatus = "delivery_status"
       // case playlistID = "playlist_id"
       // case deliveryRadius = "delivery_radius"
        case isnewBrand = "isnew_brand"
       // case isnewbrandExpiry = "isnewbrand_expiry"
       // case isnewbrandCreatedAt = "isnewbrand_created_at"
        case sku = "SKU"
        case popularCategoryID = "popular_category_id"
        case menuCard = "menu_card"
        case enableDeliveryFor = "enable_delivery_for"
        case deliveryOperateStatus = "delivery_operate_status"
        case deliveryOptions = "delivery_options"
    //    case menuType = "menu_type"
        case locationImage = "location_image"
        case busyClosedUntil = "busy_closed_until"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offers
        case outletImages = "outlet_images"
    
    }
    
    // MARK: - Images
    struct OutletImage: Codable {
        let file: String
        let id, orderBy, outletID: Int
        let type: String

        enum CodingKeys: String, CodingKey {
            case file, id, orderBy
            case outletID = "outlet_id"
            case type
        }
    }
}


// MARK: - Offer
struct UPOffer: Codable {
    let title, image, searchTags: String
    let outletID, price, specialPrice, approxSaving: Int
    let description: String
    let id: Int
    let startDatetime: String
    let endDatetime: String
    let validFor, special: String
    let specialType: String?
    let renew: String
    let redemptions, redeemed, perUser: Int
    let active: String
    let rulesOfPurchase: String
    let discountType, percentageSaving, createdAt, updatedAt: String
    //let outletName: String
    let isRedeeme, isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case title, image
        case searchTags = "search_tags"
        case outletID = "outlet_id"
        case price
        case specialPrice = "special_price"
        case approxSaving = "approx_saving"
        case description, id
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case validFor = "valid_for"
        case special
        case specialType = "special_type"
        case renew, redemptions, redeemed
        case perUser = "per_user"
        case active
        case rulesOfPurchase = "rules_of_purchase"
        case discountType = "discount_type"
        case percentageSaving = "percentage_saving"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        //case outletName = "outlet_name"
        case isRedeeme, isFavorite
    }

}

