//
//  SSOUserInfo.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/25.
//

import Foundation

struct SSOUserInfo: Decodable {
    let userID: String
    let riderName: TimeInterval

    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case riderName = "rider_name"
    }
}
