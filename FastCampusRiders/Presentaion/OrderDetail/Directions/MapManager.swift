//
//  MapManager.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/07/10.
//

import Foundation
import CoreLocation

protocol DirectionsAvailable {
    static var canOpen: Bool { get }
    var appName: String { get }
    func openAppToGetDirections(with coordinates: CLLocationCoordinate2D, name: String?)
}

enum MapManager: CaseIterable {
    case apple, google, kakao, naver
    
    static func getMapApps() -> [DirectionsAvailable] {
        var mapAppsList: [DirectionsAvailable] = []
        
        for target in MapManager.allCases {
            switch target {
            case .apple:
                if MapAppleDirections.canOpen {
                    mapAppsList.append(MapAppleDirections())
                }
            case .google:
                if MapGoogleDirections.canOpen {
                    mapAppsList.append(MapGoogleDirections())
                }
            case .kakao:
                if MapKakaoDirections.canOpen {
                    mapAppsList.append(MapKakaoDirections())
                }
            case .naver:
                if MapNaverDirections.canOpen {
                    mapAppsList.append(MapNaverDirections())
                }
            }
        }
        
        return mapAppsList
    }
}
