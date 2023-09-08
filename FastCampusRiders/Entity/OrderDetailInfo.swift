//
//  OrderDetailInfo.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/08.
//

import CoreLocation
import Foundation
import MBAkit

struct OrderDetailInfo: Decodable {
    let id: Int64
    let status: OrderStatus
    let isSingleDelivery: Bool
    let cookingEstimatedTime: Int
    
    let isRecommended: Bool
    let price: Int
    let priceUnit: String
    let itemList: [ItemDetailInfo]
    
    let distance: Int
    let memo: String?
    
    let storeInfo: LocationDetailInfo
    let destinationInfo: LocationDetailInfo
    
    var priceLabelText: String {
        return "\(self.price.formattedNumber) \(self.priceUnit)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case isSingleDelivery = "is_single_delivery"
        case cookingEstimatedTime = "cooking_estimated_time"
        case isRecommended = "is_recommended"
        case price
        case priceUnit = "price_unit"
        case itemList = "item_list"
        
        case distance
        case memo
        
        case storeInfo = "store_info"
        case destinationInfo = "destination_info"
    }
    
    enum OrderStatus: Int {
        case pending = 0
        case delivering = 1
        case completed = 2
        
        var title: String {
            switch self {
            case .pending:
                return "pending"
            case .delivering:
                return "delivering"
            case .completed:
                return "completed"
            }
        }
    }
}

extension OrderDetailInfo {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let orderId = try values.decode(String.self, forKey: .id)
        self.id = Int64(orderId)!

        self.isSingleDelivery = try values.decode(Bool.self, forKey: .isSingleDelivery)
        self.cookingEstimatedTime = try values.decode(Int.self, forKey: .cookingEstimatedTime)
        
        self.isRecommended = try values.decode(Bool.self, forKey: .isRecommended)
        self.price = try values.decode(Int.self, forKey: .price)
        self.priceUnit = try values.decode(String.self, forKey: .priceUnit)
        
        self.itemList = try values.decode([ItemDetailInfo].self, forKey: .itemList)
        
        self.distance = try values.decode(Int.self, forKey: .distance)
        self.memo = try values.decodeIfPresent(String.self, forKey: .memo)
        
        let statusValue  = try values.decode(Int.self, forKey: .status)
        if let status = OrderStatus(rawValue: statusValue) {
            self.status = status
        } else {
            throw ErrorType.parsingError
        }
        
        self.storeInfo = try values.decode(LocationDetailInfo.self, forKey: .storeInfo)
        self.destinationInfo = try values.decode(LocationDetailInfo.self, forKey: .destinationInfo)
    }
}
