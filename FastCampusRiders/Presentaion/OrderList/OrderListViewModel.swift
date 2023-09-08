//
//  OrderListViewModel.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/07.
//

import Combine
import MBAkit
import UIKit

class OrderListViewModel: ViewModelConfigurable {
    
    typealias VC = OrderListViewController
    var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()
    
    func handleMessage(_ inputMessage: VC.I) {
        switch inputMessage {
        case .getOrderList:
            self.getOrderList()
        }
    }
}

extension OrderListViewModel {
    private func getOrderList() {
        Task {
            await API.shared
                .request(path: API.Path.orderList, method: .get)
                .decode(decoder: [OrderDetailInfo].self)
                .map(VC.O.updateOrderList(orderList:))
                .send(through: self.outputSubject)
        }
    }
}