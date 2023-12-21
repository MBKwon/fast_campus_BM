//
//  OrderTrackingViewModel.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/21.
//

import Combine
import Foundation
import MBAkit

class OrderTrackingViewModel: ViewModelConfigurable {
    typealias VC = OrderTrackingViewController

    private(set) var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()

    private var cancellables = Set<AnyCancellable>()
    private lazy var locationManager = {
        let locationManager = LocationManager()
        locationManager.locationSubject
            .receive(on: DispatchQueue.main)
            .sink { result in
                result.fold(success: { locationData in
                    self.outputSubject
                        .send(.success(.updateMapView(locationData: locationData)))
                }, failure: { error in
                    self.outputSubject
                        .send(.failure(error))
                })
            }.store(in: &self.cancellables)
        return locationManager
    }()

    func handleMessage(_ inputMessage: VC.I) {
        switch inputMessage {
            case .requestLocationData:
                self.locationManager
                    .updateCurrentLocation(withHeading: true)
        }
    }
}
