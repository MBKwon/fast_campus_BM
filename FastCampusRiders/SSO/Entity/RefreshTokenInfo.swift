//
//  RefreshTokenInfo.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2024/01/04.
//

import Foundation

struct RefreshTokenInfo: Decodable {
    let accessToken: String
    let expirationTime: TimeInterval

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expirationTime = "access_token_expiration"
    }
}
