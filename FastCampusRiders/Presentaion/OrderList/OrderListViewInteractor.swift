//
//  OrderListViewInteractor.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/14.
//

import MBAkit
import UIKit

protocol OrderListDelegate: UITableViewDataSource {
    var dataList: [OrderDetailInfo] { get }
    var viewController: OrderListViewController? { get }
    
    func update(viewController: OrderListViewController)
}

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
            self.processOrderListData(dataList)
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

extension OrderListViewInteractor {
    private func updateTimeSensitiveUI(_ timer: Timer) {
        guard self.timer == timer else { return }

        guard let listView = self.currentOrderListDelegate?.viewController?.orderListView,
              let visibleIndesPaths = listView.indexPathsForVisibleRows else {
            self.stopUpdatingTimeSesitiveUI()
            return
        }

        if visibleIndesPaths.count == 0 {
            self.stopUpdatingTimeSesitiveUI()
        } else {
            listView.beginUpdates()
            listView.reloadRows(at: visibleIndesPaths, with: .automatic)
            listView.endUpdates()
        }
    }

    private func startUpdatingTimeSesitiveUI() {
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true,
                                          block: self.updateTimeSensitiveUI)
    }

    private func stopUpdatingTimeSesitiveUI() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

extension OrderListViewInteractor {
    @discardableResult
    private func selectOrderList(index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
    
    @discardableResult
    private func updateMenuView(_ stackView: FCStackView) -> Self {
        self.orderListDelegate.enumerated().forEach { sequenceElement in
            stackView.addButton(title: sequenceElement.element.title, itemTag: sequenceElement.offset)
        }
        
        return self
    }
    
    @discardableResult
    private func processOrderListData(_ dataList: [OrderDetailInfo]) -> Self {
        let pendingOrderListDelegate = PendingOrderListDelegate(with: dataList
            .filter { $0.status == .pending })
        let deliveringOrderListDelegate = InProgressOrderListDelegate(with: dataList
            .filter { $0.status == .delivering })
        let completedOrderListDelegate = CompletedOrderListDelegate(with: dataList
            .filter { $0.status == .completed })
        
        self.orderListDelegate = [
            OrderListInfo(title: "대기중 \(pendingOrderListDelegate.dataList.count)",
                          orderListDelegate: pendingOrderListDelegate),
            OrderListInfo(title: "진행 \(deliveringOrderListDelegate.dataList.count)",
                          orderListDelegate: deliveringOrderListDelegate),
            OrderListInfo(title: "완료 \(completedOrderListDelegate.dataList.count)",
                          orderListDelegate: completedOrderListDelegate)
        ]
        
        return self
    }
}
