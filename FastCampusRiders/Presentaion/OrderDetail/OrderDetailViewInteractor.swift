//
//  OrderDetailViewInteractor.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/22.
//

import Foundation
import MBAkit

class OrderDetailViewInteractor: ViewInteractorConfigurable {
    typealias VC = OrderDetailViewController
    var detailViewDelegate: OrderDetailViewDelegate?
    
    func handleMessage(_ interactionMessage: VC.IM) {
        switch interactionMessage {
        case .updateDetailView(let orderDetailInfo, let vc):
            self.detailViewDelegate = OrderDetailViewDelegate(detailInfo: orderDetailInfo, on: vc)
            vc.tableView.dataSource = detailViewDelegate
            vc.tableView.delegate = detailViewDelegate
            vc.tableView.reloadData()
        }
    }
}
