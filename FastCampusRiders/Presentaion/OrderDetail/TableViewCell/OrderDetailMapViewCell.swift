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
    
    static let cellIdentifier = "OrderDetailMapViewCell"
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var locationManager = {
        let locationManager = LocationManager()
        locationManager.locationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                result.fold(success: { location in
                    guard let self = self else { return }
                    self.mapView.setCamera(MKMapCamera(lookingAtCenter: location.coordinate,
                                                       fromEyeCoordinate: location.coordinate,
                                                       eyeAltitude: 10_000), animated: true)
                }, failure: { error in
                    print(error.localizedDescription)
                })
            }.store(in: &self.cancellables)
        
        self.mapView.showsUserLocation = true
        return locationManager
    }()
}

extension OrderDetailMapViewCell {
    func bindNavigationAction(_ action: @escaping () -> Void) {
        self.navigationButton.addAction(action)
    }
    
    @IBAction private func touchCurrentLocationButton() {
        self.locationManager.updateCurrentLocation()
    }
    
    @IBAction private func touchRouteButton() {
        
    }
}

extension OrderDetailMapViewCell: MKMapViewDelegate {
    
}
