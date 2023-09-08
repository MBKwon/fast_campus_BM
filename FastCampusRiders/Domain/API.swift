//
//  API.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/13.
//

import Foundation
import MBAkit

enum API {
    static let shared = APIController(with: APIController.APIDomainInfo(scheme: "http",
                                                                        host: "localhost",
                                                                        port: 3000))
}

extension API {
    enum Path: APIRequestPath {
        case orderDetail(orderID: Int64)
        case orderList
        
        var pathString: String {
            switch self {
            case .orderDetail(let orderID):
                return "/order_info_v5/\(orderID)"
            case .orderList:
                return "/order_info_v5"
            }
        }
        
        var parameters: [String: String]? {
            switch self {
            case .orderDetail:
                return nil
            case .orderList:
                return nil
            }
        }
    }
}
