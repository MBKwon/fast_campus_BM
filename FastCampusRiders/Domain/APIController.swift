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

        case issueToken(appID: String, secret: String, id: String, password: String)
        case refreshToken(appID: String, secret: String, refreshToken: String)
        case readUserInfo(appID: String, secret: String, accessToken: String)

        var pathString: String {
            switch self {
            case .orderDetail(let orderID):
                return "/order_info_v6/\(orderID)"
                case .orderList:
                    return "/order_info_v6"
                case .issueToken(let appID, let secret, let id, let password):
                    return "/issue_token/\(appID)_\(secret)_\(id)_\(password)"
                case .refreshToken(let appID, let secret, let refreshToken):
                    return "/refresh_token/\(appID)_\(secret)_\(refreshToken)"
                case .readUserInfo(let appID, let secret, let accessToken):
                    return "/user_info/\(appID)_\(secret)_\(accessToken)"
            }
        }

        var parameters: [String: String]? {
            switch self {
                case .orderDetail:
                    return nil
                case .orderList:
                    return nil
                case .issueToken:
                    return nil
                case .refreshToken:
                    return nil
                case .readUserInfo:
                    return nil
            }
        }
    }
}
