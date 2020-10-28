//
//  CarResult.swift
//  MeLiCarViewer
//
//  Created by David A Cespedes R on 9/14/20.
//  Copyright © 2020 David A Cespedes R. All rights reserved.
//

import Foundation

// MARK: - CarModelResult
struct CarModelResult: Codable {
  let siteID: SiteID
  let paging: Paging
  let results: [CarResult]
  let sort: Sort
  let availableSorts: [Sort]
  let filters: [Filter]
  let availableFilters: [AvailableFilter]
  
  enum CodingKeys: String, CodingKey {
    case siteID = "site_id"
    case paging, results
    case sort
    case availableSorts = "available_sorts"
    case filters
    case availableFilters = "available_filters"
  }
}

// MARK: - AvailableFilter
struct AvailableFilter: Codable {
  let id, name, type: String
  let values: [AvailableFilterValue]
}

// MARK: - AvailableFilterValue
struct AvailableFilterValue: Codable {
  let id, name: String
  let results: Int
}

// MARK: - Filter
struct Filter: Codable {
  let id, name, type: String
  let values: [FilterValue]
}

// MARK: - FilterValue
struct FilterValue: Codable {
  let id, name: String
  let pathFromRoot: [Sort]?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case pathFromRoot = "path_from_root"
  }
}

// MARK: - Paging
struct Paging: Codable {
  let total, primaryResults, offset, limit: Int
  
  enum CodingKeys: String, CodingKey {
    case total
    case primaryResults = "primary_results"
    case offset, limit
  }
}

// MARK: - CarResult
struct CarResult: Codable, Hashable {
  let id: String
  let siteID: SiteID
  let title: String
  let seller: Seller
  let price: Int
  let currencyID: CurrencyID
  let availableQuantity, soldQuantity: Int
  let buyingMode: BuyingMode
  let listingTypeID: ListingTypeID
  let stopTime: String
  let condition: Condition
  let permalink: String
  let thumbnail: String
  let acceptsMercadopago: Bool
  let installments: String?
  let address: Address
  let shipping: Shipping
  let sellerAddress: SellerAddress?
  let sellerContact: SellerContact
  let location: Location
  let attributes: [Attribute]
  let originalPrice: Int?
  let categoryID: CategoryID
  let officialStoreID: Int?
  let domainID: DomainID
  let catalogProductID: String?
  let tags: [String]
  
  enum CodingKeys: String, CodingKey {
    case id
    case siteID = "site_id"
    case title, seller, price
    case currencyID = "currency_id"
    case availableQuantity = "available_quantity"
    case soldQuantity = "sold_quantity"
    case buyingMode = "buying_mode"
    case listingTypeID = "listing_type_id"
    case stopTime = "stop_time"
    case condition, permalink, thumbnail
    case acceptsMercadopago = "accepts_mercadopago"
    case installments, address, shipping
    case sellerAddress = "seller_address"
    case sellerContact = "seller_contact"
    case location, attributes
    case originalPrice = "original_price"
    case categoryID = "category_id"
    case officialStoreID = "official_store_id"
    case domainID = "domain_id"
    case catalogProductID = "catalog_product_id"
    case tags
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: CarResult, rhs: CarResult) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - Sort
struct Sort: Codable {
  let id: String?
  let name: String
}

// MARK: - Address
struct Address: Codable {
  let stateID: String
  let stateName: String
  let cityID, cityName, areaCode, phone1: String
  
  enum CodingKeys: String, CodingKey {
    case stateID = "state_id"
    case stateName = "state_name"
    case cityID = "city_id"
    case cityName = "city_name"
    case areaCode = "area_code"
    case phone1
  }
}

// MARK: - Attribute
struct Attribute: Codable {
  let valueName: String
  let id: String
  let name: String
  let valueID: String?
  let attributeGroupName: String?
  let source: Int
  let valueStruct: Struct?
  let values: [AttributeValue]
  let attributeGroupID: String?
  
  enum CodingKeys: String, CodingKey {
    case valueName = "value_name"
    case id, name
    case valueID = "value_id"
    case attributeGroupName = "attribute_group_name"
    case source
    case valueStruct = "value_struct"
    case values
    case attributeGroupID = "attribute_group_id"
  }
}

// MARK: - Struct
struct Struct: Codable {
  let number: Float
  let unit: Unit
}

enum Unit: String, Codable {
  case cc = "cc"
  case km = "km"
}

// MARK: - AttributeValue
struct AttributeValue: Codable {
  let id: String?
  let name: String
  let valueStruct: Struct?
  let source: Int?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case valueStruct = "struct"
    case source
  }
}

// MARK: - Location
struct Location: Codable {
  let addressLine: String
  let zipCode: String
  let subneighborhood: String?
  let neighborhood, city, state, country: Sort
  let latitude, longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case addressLine = "address_line"
    case zipCode = "zip_code"
    case subneighborhood, neighborhood, city, state, country, latitude, longitude
  }
}

// MARK: - Seller
struct Seller: Codable {
  let id: Int
  let permalink: String
  let registrationDate: String
  let carDealer, realEstateAgency: Bool
  let tags: [String]
  let sellerReputation: SellerReputation
  let carDealerLogo, homeImageURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id, permalink
    case registrationDate = "registration_date"
    case carDealer = "car_dealer"
    case realEstateAgency = "real_estate_agency"
    case tags
    case sellerReputation = "seller_reputation"
    case carDealerLogo = "car_dealer_logo"
    case homeImageURL = "home_image_url"
  }
}

// MARK: - SellerReputation
struct SellerReputation: Codable {
  let transactions: Transactions
  let powerSellerStatus: String?
  let metrics: Metrics
  let levelID: String?
  
  enum CodingKeys: String, CodingKey {
    case transactions
    case powerSellerStatus = "power_seller_status"
    case metrics
    case levelID = "level_id"
  }
}

// MARK: - Metrics
struct Metrics: Codable {
  let claims, delayedHandlingTime, cancellations: MetricsStruct
  let sales: Sales
  
  enum CodingKeys: String, CodingKey {
    case claims
    case delayedHandlingTime = "delayed_handling_time"
    case sales, cancellations
  }
}

// MARK: - MetricsStruct
struct MetricsStruct: Codable {
  let rate: Float
  let value: Int
  let period: String
}

// MARK: - Sales
struct Sales: Codable {
  let period: String?
  let completed: Int?
}

// MARK: - Transactions
struct Transactions: Codable {
  let total, canceled: Int
  let period: String
  let ratings: Ratings
  let completed: Int
}

// MARK: - Ratings
struct Ratings: Codable {
  let negative, positive, neutral: Float
}

// MARK: - SellerAddress
struct SellerAddress: Codable {
  let id, comment, addressLine, zipCode: String
  let country, state, city: Sort?
  let latitude, longitude: String
  
  enum CodingKeys: String, CodingKey {
    case id, comment
    case addressLine = "address_line"
    case zipCode = "zip_code"
    case country, state, city, latitude, longitude
  }
}

// MARK: - SellerContact
struct SellerContact: Codable {
  let contact, otherInfo, areaCode, phone: String
  let areaCode2, phone2, email, webpage: String
  
  enum CodingKeys: String, CodingKey {
    case contact
    case otherInfo = "other_info"
    case areaCode = "area_code"
    case phone
    case areaCode2 = "area_code2"
    case phone2, email, webpage
  }
}

// MARK: - Shipping
struct Shipping: Codable {
  let freeShipping: Bool
  let mode: String
  let tags: [String]
  let logisticType: String?
  let storePickUp: Bool
  
  enum CodingKeys: String, CodingKey {
    case freeShipping = "free_shipping"
    case mode, tags
    case logisticType = "logistic_type"
    case storePickUp = "store_pick_up"
  }
}

enum SiteID: String, Codable {
  case mco = "MCO"
  case mla = "MLA"
}

enum BuyingMode: String, Codable {
  case classified = "classified"
}

enum CategoryID: String, Codable {
  case mco1744 = "MCO1744"
}

enum Condition: String, Codable {
  case new = "new"
  case used = "used"
}

enum CurrencyID: String, Codable {
  case cop = "COP"
  case usd = "USD"
}

enum DomainID: String, Codable {
  case mcoCarsAndVans = "MCO-CARS_AND_VANS"
}

enum ListingTypeID: String, Codable {
  case free = "free"
  case gold = "gold"
  case goldPremium = "gold_premium"
  case silver = "silver"
}
