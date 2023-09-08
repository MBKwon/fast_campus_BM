//
//  LocationDetailInfo.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/26.
//

import CoreLocation
import Foundation

struct LocationDetailInfo: Decodable {
    let name: String?
    let address: String
    let areaName: String
    let phoneNumber: String
    let locationCoordinate: CLLocationCoordinate2D
    
    var locationName: String {
        return self.name ?? self.areaName
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
        case areaName = "area_name"
        case phoneNumber = "phone_number"
        case latitude
        case longitude
    }
}

extension LocationDetailInfo {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.address = try values.decode(String.self, forKey: .address)
        self.areaName = try values.decode(String.self, forKey: .areaName)
        self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        
        let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
        self.locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
