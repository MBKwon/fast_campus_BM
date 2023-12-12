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

    private(set) var microBean: MicroBean<OrderDetailViewController,
                                          OrderDetailViewModel,
                                          OrderDetailViewInteractor>?

    private(set) var orderID: String?

    enum SegueIdentifier {
        static let completeDelivery = "completeDelivery"
        static let trackOrder = "trackOrder"
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
