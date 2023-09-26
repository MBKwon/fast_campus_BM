//
//  OrderDetailViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/15.
//

import Combine
import CoreLocation
import MapKit
import MBAkit
import UIKit

class OrderDetailViewController: UITableViewController {

    private(set) var microBean: MicroBean<OrderDetailViewController, OrderDetailViewModel, OrderDetailViewInteractor>?
    
    private(set) var orderID: String?

    enum SegueIdentifier {
        static let completeDelivery = "completeDelivery"
        static let trackOrder = "trackOrder"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.microBean = MicroBean(withVC: self,
                                   viewModel: OrderDetailViewModel(),
                                   viewInteractor: OrderDetailViewInteractor())
        
        if let orderID = self.orderID {
            self.updateDetailInfoView(with: orderID)
        } else {
            assertionFailure("orderID is nil")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.microBean?.handle(interactionMessage: .drawRoute(locations: [
            CLLocation(latitude: 37.3589, longitude: 127.1055),
            CLLocation(latitude: 37.5159, longitude: 127.0989)
        ], vc: self))
    }
}

extension OrderDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OrderCompletionViewController,
           let orderID = sender as? String {
            vc.set(orderID: orderID)
        } else if let vc = segue.destination as? OrderTrackingViewController,
                  let orderInfo = sender as? OrderDetailInfo {
            vc.set(orderInfo: orderInfo)
        }
    }
    
    func set(orderID: String) {
        self.orderID = orderID
    }
    
    func updateDetailInfoView(with orderID: String) {
        self.microBean?.handle(inputMessage: .getOrderDetail(orderID: orderID))
    }
}

extension OrderDetailViewController: ViewControllerConfigurable {
    
    typealias VM = OrderDetailViewModel
    
    typealias I = OrderDetailInputMessage
    enum OrderDetailInputMessage: InputMessage {
        case getOrderDetail(orderID: String)
    }
    
    typealias O = OrderDetailOutputMessage
    enum OrderDetailOutputMessage: OutputMessage {
        case updateOrderDetail(orderDetailInfo: OrderDetailInfo)
    }
}

extension OrderDetailViewController: ViewContollerInteractable {
    
    typealias VI = OrderDetailViewInteractor
    
    typealias IM = OrderDetailInteractionMessage
    enum OrderDetailInteractionMessage: InteractionMessage {
        case updateDetailView(orderDetailInfo: OrderDetailInfo,
                              vc: OrderDetailViewController)
        case drawRoute(locations: [CLLocation],
                       vc: OrderDetailViewController)
    }
    
    func convertToInteraction(from outputMessage: OrderDetailOutputMessage)
    -> OrderDetailInteractionMessage {
        switch outputMessage {
        case .updateOrderDetail(let orderDetailInfo):
            return .updateDetailView(orderDetailInfo: orderDetailInfo, vc: self)
        }
    }
}
