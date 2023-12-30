//
//  IssueTokenInfo.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/25.
//

import Foundation

struct IssueTokenInfo: Decodable {
    let accessToken: String
    let expirationTime: TimeInterval
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expirationTime = "access_token_expiration"
        case refreshToken = "refresh_token"
    }
}
