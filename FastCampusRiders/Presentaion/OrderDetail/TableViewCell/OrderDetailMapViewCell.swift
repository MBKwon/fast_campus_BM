//
//  OrderDetailMapViewCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/21.
//

import Combine
import MapKit
import UIKit

class OrderDetailMapViewCell: UITableViewCell {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var navigationButton: UIButton!
    @IBOutlet private weak var routeButton: UIButton!
    
    static let cellIdentifier = "OrderDetailMapViewCell"
    private var routeOverlay : MKOverlay?

    private var cancellables = Set<AnyCancellable>()
    private lazy var locationManager = {
        let locationManager = LocationManager()
        locationManager.locationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                result.fold(success: { locationData in
                    guard let self = self else { return }
                    self.mapView.setCamera(MKMapCamera(lookingAtCenter: locationData.location.coordinate,
                                                       fromEyeCoordinate: locationData.location.coordinate,
                                                       eyeAltitude: 10_000), animated: true)
                }, failure: { error in
                    print(error.localizedDescription)
                })
            }.store(in: &self.cancellables)
        
        self.mapView.showsUserLocation = true
        return locationManager
    }()
}
