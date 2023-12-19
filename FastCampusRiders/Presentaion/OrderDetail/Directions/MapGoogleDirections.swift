//
//  MapGoogleDirections.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/19.
//

import CoreLocation
import UIKit

class MapGoogleDirections: DirectionsAvailable {
    static var canOpen: Bool {
        if let mapURL = URL(string: "comgooglemaps://") {
            return UIApplication.shared.canOpenURL(mapURL)
        } else {
            return false
        }
    }

    var appName: String {
        return "Google"
    }

    func openAppToGetDirections(with coordinates: CLLocationCoordinate2D, name: String?) {
        let urlString = "comgooglemapsurl://maps.google.com/?q=@\(coordinates.latitude),\(coordinates.longitude)"
        guard let mapURL = URL(string: urlString) else { return }
        UIApplication.shared.open(mapURL)
    }
}
