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
    
    private var defaultColor: UIColor {
        return UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 1)
    }
    private var highlightedColor: UIColor {
        return UIColor(red: 0.157, green: 0.761, blue: 0.737, alpha: 1)
    }
    
    private(set) var orderDetailInfo: OrderDetailInfo?
    
    private(set) var microBean: MicroBean<OrderTrackingViewController, OrderTrackingViewModel, OrderTrackingViewInteractor>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.microBean = MicroBean(withVC: self,
                                   viewModel: OrderTrackingViewModel(),
                                   viewInteractor: OrderTrackingViewInteractor())

        self.startPoint.layer.cornerRadius = 4.5
        self.midPoint.layer.cornerRadius = 4.5
        self.endPoint.layer.cornerRadius = 4.5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let orderDetailInfo = self.orderDetailInfo else {
            assertionFailure("orderDetailInfo is nil")
            return
        }
        
        let animator = UIViewPropertyAnimator(duration: 1.4, curve: .easeOut)
        animator.addAnimations {
            // Add animation code here
            switch orderDetailInfo.status {
            case .pending:
                self.setStartStatus()
            case .delivering:
                self.setDelivaryStatus()
            case .completed:
                self.setCompleteStatus()
            }
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        self.microBean?.handle(inputMessage: .requestLocationData)
    }
}

extension OrderTrackingViewController: ViewControllerConfigurable {
    
    typealias VM = OrderTrackingViewModel

    typealias I = OrderTrackingInputMessage
    enum OrderTrackingInputMessage: InputMessage {
        case requestLocationData
    }

    typealias O = OrderTrackingOutputMessage
    enum OrderTrackingOutputMessage: OutputMessage {
        case updateMapView(locationData: LocationManager.LocationData)
    }
}

extension OrderTrackingViewController: ViewContollerInteractable {
    
    typealias VI = OrderTrackingViewInteractor

    typealias IM = OrderTrackingInteractionMessage
    enum OrderTrackingInteractionMessage: InteractionMessage {
        case displayLocationOnMapView(mapView: MKMapView, locationData: LocationManager.LocationData)
    }

    func convertToInteraction(from outputMessage: OrderTrackingOutputMessage) -> OrderTrackingInteractionMessage {
        switch outputMessage {
        case .updateMapView(let locationData):
            return .displayLocationOnMapView(mapView: self.mapView, locationData: locationData)
        }
    }
}

extension OrderTrackingViewController {
    func set(orderInfo: OrderDetailInfo) {
        self.orderDetailInfo = orderInfo
    }
}

extension OrderTrackingViewController {
    private func setStartStatus() {
        self.indicatorStartConstraint.priority = .defaultHigh
        self.indicatorDelivaryConstraint.priority = .defaultLow
        self.indicatorCompletionConstraint.priority = .defaultLow
        
        self.progressStartConstraint.priority = .defaultHigh
        self.progressDelivaryConstraint.priority = .defaultLow
        self.progressCompletionConstraint.priority = .defaultLow
        
        self.startLabel.textColor = self.highlightedColor
        self.midLabel.textColor = self.defaultColor
        self.endLabel.textColor = self.defaultColor
    }
    
    private func setDelivaryStatus() {
        self.indicatorStartConstraint.priority = .defaultLow
        self.indicatorDelivaryConstraint.priority = .defaultHigh
        self.indicatorCompletionConstraint.priority = .defaultLow
        
        self.progressStartConstraint.priority = .defaultLow
        self.progressDelivaryConstraint.priority = .defaultHigh
        self.progressCompletionConstraint.priority = .defaultLow
        
        self.startLabel.textColor = self.highlightedColor
        self.midLabel.textColor = self.highlightedColor
        self.endLabel.textColor = self.defaultColor
    }
    
    private func setCompleteStatus() {
        self.indicatorStartConstraint.priority = .defaultLow
        self.indicatorDelivaryConstraint.priority = .defaultLow
        self.indicatorCompletionConstraint.priority = .defaultHigh
        
        self.progressStartConstraint.priority = .defaultLow
        self.progressDelivaryConstraint.priority = .defaultLow
        self.progressCompletionConstraint.priority = .defaultHigh
        
        self.startLabel.textColor = self.highlightedColor
        self.midLabel.textColor = self.highlightedColor
        self.endLabel.textColor = self.highlightedColor
    }
}
