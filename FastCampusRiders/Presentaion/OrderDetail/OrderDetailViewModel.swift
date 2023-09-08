//
//  OrderDetailViewModel.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/22.
//

import Combine
import Foundation
import MBAkit

class OrderDetailViewModel: ViewModelConfigurable {
    typealias VC = OrderDetailViewController
    
    private(set) var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()
    
    func handleMessage(_ inputMessage: OrderDetailViewController.OrderDetailInputMessage) {
        switch inputMessage {
        case .getOrderDetail(let orderID):
            self.requestOrderDetailInfo(with: orderID)
        }
    }
}

extension OrderDetailViewModel {
    private func requestOrderDetailInfo(with orderID: Int64) {
        Task {
            await API.shared
                .request(path: API.Path.orderDetail(orderID: orderID), method: .get)
                .decode(decoder: OrderDetailInfo.self)
                .map(VC.O.updateOrderDetail(orderDetailInfo:))
                .send(through: self.outputSubject)
        }
    }
}
