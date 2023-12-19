//
//  MapKakaoDirections.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/19.
//

import CoreLocation
import UIKit

class MapKakaoDirections: DirectionsAvailable {
    static var canOpen: Bool {
        if let mapURL = URL(string: "kakaomap://") {
            return UIApplication.shared.canOpenURL(mapURL)
        } else {
            return false
        }
    }

    var appName: String {
        return "Kakao"
    }

    func openAppToGetDirections(with coordinates: CLLocationCoordinate2D, name: String?) {
        let urlString = "kakaomap://look?p=\(coordinates.latitude),\(coordinates.longitude)"
        guard let mapURL = URL(string: urlString) else { return }
        UIApplication.shared.open(mapURL)
    }
}
