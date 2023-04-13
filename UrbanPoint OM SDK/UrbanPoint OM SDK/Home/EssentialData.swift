//
//  EssentialData.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/29/23.
//

import Foundation

// MARK: - Welcome
struct EssentialData: Codable {
    let status: String
    let statusCode: Int
    let message: String
    let data: DataData
}


// MARK: - DataData
struct DataData: Codable {
    let defaults: Defaults
    let superAccessPin: String
    let offerUsedAgain: [UseAgainOffer]
    let subscriptionBanner: [SubscriptionBanner]
    let nearbyOutlets: [NearbyOutlet]

    enum CodingKeys: String, CodingKey {
        case defaults
        case superAccessPin = "super_access_pin"
        case offerUsedAgain
        case subscriptionBanner = "subscription_banner"
        case nearbyOutlets
    }
}

// MARK: - Defaults
struct Defaults: Codable {
    let uber: String
    let creditCardScreen: [CreditCardScreen]
    let version: Version
    let trendingSearch: [TrendingSearch]
    let subscriptionText1: [SubscriptionText1]

    enum CodingKeys: String, CodingKey {
        case uber
        case creditCardScreen = "credit_card_screen"
        case version
        case trendingSearch = "trending_search"
        case subscriptionText1 = "subscription_text_1"
    }
}

// MARK: - CreditCardScreen
struct CreditCardScreen: Codable {
    let text, textAr: String

    enum CodingKeys: String, CodingKey {
        case text
        case textAr = "text_ar"
    }
}

// MARK: - SubscriptionText1
struct SubscriptionText1: Codable {
    let text: String
}

// MARK: - TrendingSearch
struct TrendingSearch: Codable {
    let text, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case text
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Version
struct Version: Codable {
    let version, forcefullyUpdated: String

    enum CodingKeys: String, CodingKey {
        case version
        case forcefullyUpdated = "forcefully_updated"
    }
}

// MARK: - NearbyOutlet
struct NearbyOutlet: Codable {
    let name, image: String
    let id, isMultipleChild, offersCount: Int
    let distance: String
    let linkedOutletCategory: [LinkedOutletCategory]
    let outletsParents: OutletsParents

    enum CodingKeys: String, CodingKey {
        case name, image, id, isMultipleChild, offersCount, distance
        case linkedOutletCategory = "linked_outlet_category"
        case outletsParents = "outlets_parents"
    }
}

// MARK: - LinkedOutletCategory
struct LinkedOutletCategory: Codable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let imageV2: String?
    let logo: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, image
        case imageV2 = "image_v2"
        case logo
    }
}







struct UseAgainOffer: Codable{
    let id: Int
}
struct SubscriptionBanner: Codable{}
