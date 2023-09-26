//
//  APIController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/13.
//

import Foundation
import MBAkit

// json-server --host 192.168.100.76 --port 3000 --watch db.json
enum APIController {
    static let shared = API(with: API.APIDomainInfo(scheme: "http",
                                                    host: "localhost", //192.168.100.76",
                                                    port: 3000,
                                                    cachePolicy: .reloadIgnoringCacheData))
}

extension APIController {
    enum Path: APIPath {
        case orderDetail(orderID: String)
        case orderList
        
        var pathString: String {
            switch self {
            case .orderDetail(let orderID):
                return "/order_info_v6/\(orderID)"
            case .orderList:
                return "/order_info_v6"
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
