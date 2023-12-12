//
//  OrderListViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/05.
//

import Combine
import MBAkit
import UIKit

final class OrderListViewController: UIViewController {

    @IBOutlet private weak var orderCategoryView: FCStackView!

    @IBOutlet weak var orderListView: UITableView!
    @IBOutlet weak var orderCategoryViewHeight: NSLayoutConstraint!

    private(set) var microBean: MicroBean<OrderListViewController, OrderListViewModel, OrderListViewInteractor>?
}

extension OrderListViewController: ViewControllerConfigurable {
    typealias VM = OrderListViewModel

    typealias I = OrderListInput
    enum OrderListInput: InputMessage {
        case getOrderList
    }

    typealias O = OrderListOutput
    enum OrderListOutput: OutputMessage {
        case updateOrderList(orderList: [OrderDetailInfo])
    }

}

extension OrderListViewController: ViewContollerInteractable {
    typealias VI = OrderListViewInteractor

    typealias IM = OrderListIM
    enum OrderListIM: InteractionMessage {
        case updateOrderList(dataList: [OrderDetailInfo],
                             categoryView: FCStackView,
                             vc: OrderListViewController)

        case selectIndex(index: Int, vc: OrderListViewController)

        case suspendTimer
        case resumeTimer
    }

    func convertToInteraction(from outputMessage: OrderListOutput) -> OrderListIM {
        switch outputMessage {
        case .updateOrderList(let orderList):
            return .updateOrderList(dataList: orderList,
                                    categoryView: self.orderCategoryView,
                                    vc: self)
        }
    }
}
