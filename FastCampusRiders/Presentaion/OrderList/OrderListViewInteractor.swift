//
//  OrderListViewInteractor.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/12.
//

import MBAkit
import UIKit

protocol OrderListDelegate: UITableViewDataSource {
    var dataList: [OrderDetailInfo] { get }
    var viewController: OrderListViewController? { get }
    var scrollDelegate: ((UIScrollView) -> Void)? { set get }

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
                self.processOrderListData(dataList, on: vc)
                    .updateMenuView(categoryView)
                    .currentOrderListDelegate?
                    .update(viewController: vc)
                self.stopUpdatingtimeSensitiveUI()

            case .selectIndex(let index, let vc):
                self.selectOrderList(index: index)
                    .currentOrderListDelegate?
                    .update(viewController: vc)

            case .suspendTimer:
                self.startUpdatingTimeSensitiveUI()
            case .resumeTimer:
                self.stopUpdatingtimeSensitiveUI()
        }
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
            stackView.addButton(title: sequenceElement.element.title,
                                itemTag: sequenceElement.offset)
        }
        return self
    }
}

extension OrderListViewInteractor {
    private func startUpdatingTimeSensitiveUI() {
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0,
                                          repeats: true, 
                                          block: updateTimeSensitiveUI(_:))
    }

    private func stopUpdatingtimeSensitiveUI() {
        self.timer?.invalidate()
        self.timer = nil
    }

    private func updateTimeSensitiveUI(_ timer: Timer) {
        guard self.timer == timer else { return }

        guard let listView = self.currentOrderListDelegate?.viewController?.orderListView,
              let visibleIndexPaths = listView.indexPathsForVisibleRows else {
            self.stopUpdatingtimeSensitiveUI()
            return
        }

        if visibleIndexPaths.count == 0 {
            self.stopUpdatingtimeSensitiveUI()
        } else {
            listView.beginUpdates()
            listView.reloadRows(at: visibleIndexPaths, with: .automatic)
            listView.endUpdates()
        }
    }
}

extension OrderListViewInteractor {

    @discardableResult
    private func processOrderListData(_ dataList: [OrderDetailInfo], on viewController: VC) -> Self {
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

        self.orderListDelegate.forEach { listInfo in
            listInfo.orderListDelegate.scrollDelegate = { (scrollView) in
                let offsetY = scrollView.contentOffset.y
                let maxHeight = 57.0
                let minHeight = 30.0

                let viewHeight = max(maxHeight - offsetY / 10, minHeight)
                viewController.orderCategoryViewHeight.constant = viewHeight
            }
        }

        return self
    }
}
