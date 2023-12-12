//
//  OrderListViewInteractor.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/12.
//

import MBAkit
import UIKit

class OrderListViewInteractor {

    struct OrderListInfo {
        let title: String
        let orderListDelegate: OrderListDelegate
    }

    private var timer: Timer?
    private var selectedIndex: Int = 0
    private(set) var orderListDelegate: [OrderListInfo] = []
    var currentOrderListDelegate: OrderListDelegate? {
        return self.orderListDelegate[safe: self.selectedIndex]?.orderListDelegate
    }
}

extension OrderListViewInteractor: ViewInteractorConfigurable {
    typealias VC = OrderListViewController

    func handleMessage(_ interactionMessage: VC.IM) {
        switch interactionMessage {
            case .updateOrderList(let dataList, let categoryView, let vc):
                self.processOrderListData(dataList, on: vc)
                    .updateMenuView(categoryView)
                    .currentOrderListDelegate?
                    .update(viewController: vc)
                self.startUpdatingTimeSesitiveUI()

            case .selectIndex(let index, let vc):
                self.selectOrderList(index: index)
                    .currentOrderListDelegate?
                    .update(viewController: vc)

            case .suspendTimer:
                self.stopUpdatingTimeSesitiveUI()
            case .resumeTimer:
                self.startUpdatingTimeSesitiveUI()
        }
    }
}
