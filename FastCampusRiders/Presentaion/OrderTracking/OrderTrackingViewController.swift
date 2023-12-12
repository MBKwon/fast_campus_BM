//
//  OrderTrackingViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/10/01.
//

import Combine
import MapKit
import MBAkit
import UIKit

class OrderTrackingViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!

    @IBOutlet private weak var startPoint: UIView!
    @IBOutlet private weak var midPoint: UIView!
    @IBOutlet private weak var endPoint: UIView!

    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var midLabel: UILabel!
    @IBOutlet private weak var endLabel: UILabel!

    @IBOutlet private weak var indicatorStartConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorDelivaryConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorCompletionConstraint: NSLayoutConstraint!

    @IBOutlet private weak var progressStartConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressDelivaryConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressCompletionConstraint: NSLayoutConstraint!

}
