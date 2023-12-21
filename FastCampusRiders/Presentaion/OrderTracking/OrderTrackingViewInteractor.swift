//
//  OrderTrackingViewInteractor.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/21.
//

import CoreLocation
import MapKit
import MBAkit
import UIKit

class OrderTrackingViewInteractor: ViewInteractorConfigurable {
    
    typealias VC = OrderTrackingViewController
    private lazy var mapViewDelegate = TrackingMapViewDelegate()

    private var latestAnnotation: RiderAnnotation?

    func handleMessage(_ interactionMessage: VC.IM) {
        switch interactionMessage {
            case .displayLocationOnMapView(let mapView, let locationData):
                mapView.setCamera(MKMapCamera(lookingAtCenter: locationData.location.coordinate,
                                              fromEyeCoordinate: locationData.location.coordinate,
                                              eyeAltitude: 10_000), animated: true)

                mapView.delegate = self.mapViewDelegate
                if let exAnnotation = self.latestAnnotation {
                    mapView.removeAnnotation(exAnnotation)
                }

                let annotation = RiderAnnotation(coordinate: locationData.location.coordinate,
                                                 heading: locationData.heading)

                mapView.addAnnotation(annotation)
                self.latestAnnotation = annotation
        }
    }
}

private class TrackingMapViewDelegate: NSObject {
    private let userAnnotationViewID = "userAnnotationViewID"
}

extension TrackingMapViewDelegate: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is RiderAnnotation {
            return RiderAnnotationView(annotation: annotation,
                                       reuseIdentifier: userAnnotationViewID)
        } else {
            return nil
        }
    }
}

private class RiderAnnotation: NSObject, MKAnnotation {
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var heading: CLHeading?

    init(coordinate: CLLocationCoordinate2D, heading: CLHeading?) {
        self.coordinate = coordinate
        self.heading = heading
    }
}

private class RiderAnnotationView: MKAnnotationView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: "icon_rider_location")

        if let riderAnnotation = annotation as? RiderAnnotation,
           var headingDirection = riderAnnotation.heading?.magneticHeading {

            if headingDirection >= 0 {
                headingDirection = fabs(headingDirection)
            } else if headingDirection < 0 {
                headingDirection = 360 - headingDirection
            }

            let headingInRadians = headingDirection * Double.pi / 180
            self.layer.setAffineTransform(CGAffineTransformMakeRotation(headingInRadians))
        }
    }
}
