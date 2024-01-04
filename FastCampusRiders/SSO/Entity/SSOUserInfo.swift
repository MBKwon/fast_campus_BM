//
//  SSOUserInfo.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2024/01/04.
//

import Foundation

struct SSOUserInfo: Decodable {
    let userID: String
    let riderName: String

    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case riderName = "rider_name"
    }
}
